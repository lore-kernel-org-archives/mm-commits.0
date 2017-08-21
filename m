From: akpm@linux-foundation.org
Subject: [merged] kmod-fix-wait-on-recursive-loop.patch removed
 from -mm tree
Date: Mon, 21 Aug 2017 11:30:01 -0700
Message-ID: <20170821183001.yBx7ln8NN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753701AbdHUSaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 14:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, matt.redfearn@imgetc.com, matt.redfearn@imgtec.com, mbenes@suse.cz, mcgrof@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, mmarek@suse.com, peterz@infradead.org, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org


The patch titled
     Subject: kmod: fix wait on recursive loop
has been removed from the -mm tree.  Its filename was
     kmod-fix-wait-on-recursive-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: fix wait on recursive loop

Recursive loops with module loading were previously handled in kmod by
restricting the number of modprobe calls to 50 and if that limit was
breached request_module() would return an error and a user would see the
following on their kernel dmesg:

request_module: runaway loop modprobe binfmt-464c
Starting init:/sbin/init exists but couldn't execute it (error -8)

This issue could happen for instance when a 64-bit kernel boots a 32-bit
userspace on some architectures and has no 32-bit binary format hanlders. 
This is visible, for instance, when a CONFIG_MODULES enabled 64-bit MIPS
kernel boots a into o32 root filesystem and the binfmt handler for o32
binaries is not built-in.

After commit 6d7964a722af ("kmod: throttle kmod thread limit") we now
don't have any visible signs of an error and the kernel just waits for the
loop to end somehow.

Although this *particular* recursive loop could also be addressed by doing
a sanity check on search_binary_handler() and disallowing a modular binfmt
to be required for modprobe, a generic solution for any recursive kernel
kmod issues is still needed.

This should catch these loops.  We can investigate each loop and address
each one separately as they come in, this however puts a stop gap for them
as before.

Link: http://lkml.kernel.org/r/20170809234635.13443-3-mcgrof@kernel.org
Fixes: 6d7964a722af ("kmod: throttle kmod thread limit")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: Matt Redfearn <matt.redfearn@imgtec.com>
Tested-by: Matt Redfearn <matt.redfearn@imgetc.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-fix-wait-on-recursive-loop kernel/kmod.c
--- a/kernel/kmod.c~kmod-fix-wait-on-recursive-loop
+++ a/kernel/kmod.c
@@ -71,6 +71,18 @@ static atomic_t kmod_concurrent_max = AT
 static DECLARE_WAIT_QUEUE_HEAD(kmod_wq);
 
 /*
+ * This is a restriction on having *all* MAX_KMOD_CONCURRENT threads
+ * running at the same time without returning. When this happens we
+ * believe you've somehow ended up with a recursive module dependency
+ * creating a loop.
+ *
+ * We have no option but to fail.
+ *
+ * Userspace should proactively try to detect and prevent these.
+ */
+#define MAX_KMOD_ALL_BUSY_TIMEOUT 5
+
+/*
 	modprobe_path is set via /proc/sys.
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
@@ -167,8 +179,17 @@ int __request_module(bool wait, const ch
 		pr_warn_ratelimited("request_module: kmod_concurrent_max (%u) close to 0 (max_modprobes: %u), for module %s, throttling...",
 				    atomic_read(&kmod_concurrent_max),
 				    MAX_KMOD_CONCURRENT, module_name);
-		wait_event_interruptible(kmod_wq,
-					 atomic_dec_if_positive(&kmod_concurrent_max) >= 0);
+		ret = wait_event_killable_timeout(kmod_wq,
+						  atomic_dec_if_positive(&kmod_concurrent_max) >= 0,
+						  MAX_KMOD_ALL_BUSY_TIMEOUT * HZ);
+		if (!ret) {
+			pr_warn_ratelimited("request_module: modprobe %s cannot be processed, kmod busy with %d threads for more than %d seconds now",
+					    module_name, MAX_KMOD_CONCURRENT, MAX_KMOD_ALL_BUSY_TIMEOUT);
+			return -ETIME;
+		} else if (ret == -ERESTARTSYS) {
+			pr_warn_ratelimited("request_module: sigkill sent for modprobe %s, giving up", module_name);
+			return ret;
+		}
 	}
 
 	trace_module_request(module_name, wait, _RET_IP_);
_

Patches currently in -mm which might be from mcgrof@kernel.org are

kmod-split-out-umh-code-into-its-own-file.patch
maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch
kmod-split-off-umh-headers-into-its-own-file.patch
kmod-move-ifdef-config_modules-wrapper-to-makefile.patch

