From: akpm@linux-foundation.org
Subject: + lib-replace-remaining-__function__-occurances.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:26:10 -0800
Message-ID: <200803030826.m238QAfi006673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbYCCI0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     lib: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     lib-replace-remaining-__function__-occurances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c        |   16 ++++++++--------
 lib/kobject_uevent.c |   10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN lib/kobject.c~lib-replace-remaining-__function__-occurances lib/kobject.c
--- a/lib/kobject.c~lib-replace-remaining-__function__-occurances
+++ a/lib/kobject.c
@@ -146,7 +146,7 @@ static void fill_kobj_path(struct kobjec
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: path = '%s'\n", kobject_name(kobj),
-		 kobj, __FUNCTION__, path);
+		 kobj, __func__, path);
 }
 
 /**
@@ -237,7 +237,7 @@ static int kobject_add_internal(struct k
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: parent: '%s', set: '%s'\n",
-		 kobject_name(kobj), kobj, __FUNCTION__,
+		 kobject_name(kobj), kobj, __func__,
 		 parent ? kobject_name(parent) : "<NULL>",
 		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>");
 
@@ -252,10 +252,10 @@ static int kobject_add_internal(struct k
 			printk(KERN_ERR "%s failed for %s with "
 			       "-EEXIST, don't try to register things with "
 			       "the same name in the same directory.\n",
-			       __FUNCTION__, kobject_name(kobj));
+			       __func__, kobject_name(kobj));
 		else
 			printk(KERN_ERR "%s failed for %s (%d)\n",
-			       __FUNCTION__, kobject_name(kobj), error);
+			       __func__, kobject_name(kobj), error);
 		dump_stack();
 	} else
 		kobj->state_in_sysfs = 1;
@@ -597,7 +597,7 @@ static void kobject_cleanup(struct kobje
 	const char *name = kobj->name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
@@ -657,7 +657,7 @@ void kobject_put(struct kobject *kobj)
 
 static void dynamic_kobj_release(struct kobject *kobj)
 {
-	pr_debug("kobject: (%p): %s\n", kobj, __FUNCTION__);
+	pr_debug("kobject: (%p): %s\n", kobj, __func__);
 	kfree(kobj);
 }
 
@@ -714,7 +714,7 @@ struct kobject *kobject_create_and_add(c
 	retval = kobject_add(kobj, parent, "%s", name);
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
-		       __FUNCTION__, retval);
+		       __func__, retval);
 		kobject_put(kobj);
 		kobj = NULL;
 	}
@@ -823,7 +823,7 @@ static void kset_release(struct kobject 
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 	kfree(kset);
 }
 
diff -puN lib/kobject_uevent.c~lib-replace-remaining-__function__-occurances lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~lib-replace-remaining-__function__-occurances
+++ a/lib/kobject_uevent.c
@@ -99,7 +99,7 @@ int kobject_uevent_env(struct kobject *k
 	int retval = 0;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
@@ -109,7 +109,7 @@ int kobject_uevent_env(struct kobject *k
 	if (!top_kobj->kset) {
 		pr_debug("kobject: '%s' (%p): %s: attempted to send uevent "
 			 "without kset!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return -EINVAL;
 	}
 
@@ -121,7 +121,7 @@ int kobject_uevent_env(struct kobject *k
 		if (!uevent_ops->filter(kset, kobj)) {
 			pr_debug("kobject: '%s' (%p): %s: filter function "
 				 "caused the event to drop!\n",
-				 kobject_name(kobj), kobj, __FUNCTION__);
+				 kobject_name(kobj), kobj, __func__);
 			return 0;
 		}
 
@@ -133,7 +133,7 @@ int kobject_uevent_env(struct kobject *k
 	if (!subsystem) {
 		pr_debug("kobject: '%s' (%p): %s: unset subsystem caused the "
 			 "event to drop!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return 0;
 	}
 
@@ -175,7 +175,7 @@ int kobject_uevent_env(struct kobject *k
 		if (retval) {
 			pr_debug("kobject: '%s' (%p): %s: uevent() returned "
 				 "%d\n", kobject_name(kobj), kobj,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 			goto exit;
 		}
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch

