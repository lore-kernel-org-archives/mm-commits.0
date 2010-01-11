From: akpm@linux-foundation.org
Subject: [merged] kmod-fix-resource-leak-in-call_usermodehelper_pipe.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:51 -0800
Message-ID: <201001112017.o0BKHp7Y025436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997Ab0AKUTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kmod: fix resource leak in call_usermodehelper_pipe()
has been removed from the -mm tree.  Its filename was
     kmod-fix-resource-leak-in-call_usermodehelper_pipe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmod: fix resource leak in call_usermodehelper_pipe()
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix resource (write-pipe file) leak in call_usermodehelper_pipe().

When call_usermodehelper_exec() fails, write-pipe file is opened and
call_usermodehelper_pipe() just returns an error.  Since it is hard for
caller to determine whether the error occured when opening the pipe or
executing the helper, the caller cannot close the pipe by themselves.

I've found this resoruce leak when testing coredump.  You can check how
the resource leaks as below;

$ echo "|nocommand" > /proc/sys/kernel/core_pattern
$ ulimit -c unlimited
$ while [ 1 ]; do ./segv; done &> /dev/null &
$ cat /proc/meminfo (<- repeat it)

where segv.c is;
//-----
int main () {
        char *p = 0;
        *p = 1;
}
//-----

This patch closes write-pipe file if call_usermodehelper_exec() failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/kmod.c~kmod-fix-resource-leak-in-call_usermodehelper_pipe kernel/kmod.c
--- a/kernel/kmod.c~kmod-fix-resource-leak-in-call_usermodehelper_pipe
+++ a/kernel/kmod.c
@@ -520,13 +520,15 @@ int call_usermodehelper_pipe(char *path,
 		return -ENOMEM;
 
 	ret = call_usermodehelper_stdinpipe(sub_info, filp);
-	if (ret < 0)
-		goto out;
+	if (ret < 0) {
+		call_usermodehelper_freeinfo(sub_info);
+		return ret;
+	}
 
-	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+	if (ret < 0)	/* Failed to execute helper, close pipe */
+		filp_close(*filp, NULL);
 
-  out:
-	call_usermodehelper_freeinfo(sub_info);
 	return ret;
 }
 EXPORT_SYMBOL(call_usermodehelper_pipe);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
cpumask-let-num__cpus-function-always-return-unsigned-values.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch

