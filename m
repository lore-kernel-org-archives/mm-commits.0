Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793415181;
	b=WH3fUQ4oTdVoXeO/tAIoNof+R/oUvqpg4f2gvovKAp2qTEKoxD9c7bdh+x4OKBrgoNax
	 C6qRqMHkIFSsChFXS2zLEdFqXP58+dDm8yP9kmVcyMkQ5Hgt/8k+QQXIxeeU9WUAHdV6K
	 CzD8qf9YZALt8xYczNgr9xkv1Tu2uTtm6TRBEIl45mVLrtQ8Q291m2ALC+6Bi+FUClJF/
	 zfeRjC/dEK+CBgmDg1gzJo531DSI0YbyHKnE5YH4sPTwyyQDFelcYTLOJKszOSY51L/7R
	 H6k48zcoj7kxTueNVQ8xBPQZeiYat8VVI7Ci2R1mvBbKNOXvZySZiA2HfV1+HFeZ7IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793415181;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=823plt3PyffP3ZYmuJF9wjGMDzFAngVy7Kwn93lFjSw=;
	b=rWp33qt7RmIF75tzY8NCTQ+Qh5lsEK+PKJp7xidIjADW7Dye1erp1RnEZ7KO2EzMR5t9
	 YNEAJ9Vt502X7IWQdfM6NV9GOq8X796DJfYwTFvrBizfeNkQqXpqti/BTNPk3aE2X3xbw
	 A4nANzvL0W6KO091w4gR/HrU2Tn4OXUNWVs51cuWCA0kq58kzM4Vh9MQ49Xp3uXVzwqcL
	 sdxnwX/OAT46MRI8C2qxSm0b5dGTrOX/y1f0t4LZ2HHVFaCIayL2Wb4K830It6UFO7Gg+
	 2HiPMNAY8fMV8kL3kjAEyH2VI6TrIoD6o1Xm67eBSwIElhBb1dCLZbJDbrSAIa8v8XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GMp8XZfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FFA606A320;
	Sat, 31 Oct 2026 02:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GMp8XZfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46141F000C1;
	Sat, 31 Oct 2026 02:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793415180;
	bh=823plt3PyffP3ZYmuJF9wjGMDzFAngVy7Kwn93lFjSw=;
	h=Date:To:From:Subject;
	b=GMp8XZfrhhYQWmVTFCAaLiOzIu8knDAAUwOJNypI+znLXtwmc69XV3UgNSgJMseLW
	 8H0CH6BnlnhdFYzUnUNZT6rT8UYk9BbQm9oMl74MmJG2YY5OQ3Fs/e0IW/1f7G4yY0
	 lsnLX3qxye2QyqAIc30jP9q5tdtf8ui0hq9T2lmE=
Date: Fri, 30 Oct 2026 19:53:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	shyamsaini@linux.microsoft.com,samitolvanen@google.com,petr.pavlu@suse.com,
	kees@kernel.org,gregkh@linuxfoundation.org,xujiakai24@mails.ucas.ac.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + params-serialize-lookup_or_create_module_kobject.patch added to mm-nonmm-unstable branch
Message-Id: <20261031025300.C46141F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: params: serialize lookup_or_create_module_kobject()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     params-serialize-lookup_or_create_module_kobject.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/params-serialize-lookup_or_create_module_kobject.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Subject: params: serialize lookup_or_create_module_kobject()
Date: Fri, 18 Sep 2026 10:07:12 +0000

lookup_or_create_module_kobject() first looks up the module kobject with
kset_find_obj() and, if not found, creates a new one with
kobject_init_and_add().  The function is called at runtime from
module_add_driver() since commit f95bbfe18512 ("drivers: base: handle
module_kobject creation"), which means two concurrent driver
registrations for the same built-in module name can both miss the
lookup and race to create the same kobject.

The loser of the race gets -EEXIST from kobject_init_and_add() and its
kobject is removed from module_kset by kobject_add_internal() before
the failure is reported.  The error path then calls kobject_put(),
which invokes module_kobj_release(), but that only completes
->kobj_completion and never frees the dynamically allocated
module_kobject, leaking it (96 bytes) along with the object having been
detached from the kset.

This is triggerable by unprivileged users, e.g. by concurrently issuing
the USB_RAW_IOCTL_RUN ioctl of the raw-gadget driver, which registers the
"raw_gadget" driver on the gadget bus:

  sysfs: cannot create duplicate filename '/module/raw_gadget'
  ...
  Adding module 'raw_gadget' to sysfs failed (-17), the system may be
  unstable.
  ...
  unreferenced object 0xffff8880188dacc0 (size 96):
    backtrace:
      lookup_or_create_module_kobject+0x47/0x100
      module_add_driver+0x73/0x1b0
      bus_add_driver+0x1d9/0x340
      driver_register+0xde/0x170

Fix it by serializing the lookup and the creation with a mutex, so that
the second caller finds the kobject created by the first one instead of
racing with it.

The patch fixes the module_kobject leak in this specific race condition,
but not in cases when kobject_init_and_add() (or sysfs_create_file())
fails for another reason.  

Link: https://lore.kernel.org/20260918100712.3124994-1-xujiakai24@mails.ucas.ac.cn
Fixes: f95bbfe18512 ("drivers: base: handle module_kobject creation")
Fixes: 7c76c813cfc4 ("kernel: globalize lookup_or_create_module_kobject()")
Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
---

 kernel/params.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/params.c~params-serialize-lookup_or_create_module_kobject
+++ a/kernel/params.c
@@ -3,6 +3,7 @@
  * Helpers for initial module or kernel cmdline parsing
  * Copyright (C) 2001 Rusty Russell.
  */
+#include <linux/cleanup.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -20,6 +21,12 @@
 /* Protects all built-in parameters, modules use their own param_lock */
 static DEFINE_MUTEX(param_lock);
 
+/*
+ * Serializes module kobject lookup and creation in
+ * lookup_or_create_module_kobject()
+ */
+static DEFINE_MUTEX(mod_kobject_mutex);
+
 /* Use the module's mutex, or if built-in use the built-in mutex */
 #ifdef CONFIG_MODULES
 #define KPARAM_MUTEX(mod)	((mod) ? &(mod)->param_lock : &param_lock)
@@ -754,6 +761,13 @@ lookup_or_create_module_kobject(const ch
 	struct kobject *kobj;
 	int err;
 
+	/*
+	 * The lookup and the creation must be done atomically, otherwise
+	 * concurrent callers may race to create the same kobject, and the
+	 * loser of the race gets -EEXIST from kobject_init_and_add().
+	 */
+	guard(mutex)(&mod_kobject_mutex);
+
 	kobj = kset_find_obj(module_kset, name);
 	if (kobj)
 		return to_module_kobject(kobj);
_

Patches currently in -mm which might be from xujiakai24@mails.ucas.ac.cn are

params-serialize-lookup_or_create_module_kobject.patch

