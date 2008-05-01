From: akpm@linux-foundation.org
Subject: - lib-replace-remaining-__function__-occurances.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:11 -0700
Message-ID: <200805010933.m419XBxb031118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbYEAJdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     lib-replace-remaining-__function__-occurances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: replace remaining __FUNCTION__ occurrences
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
@@ -90,7 +90,7 @@ static void fill_kobj_path(struct kobjec
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: path = '%s'\n", kobject_name(kobj),
-		 kobj, __FUNCTION__, path);
+		 kobj, __func__, path);
 }
 
 /**
@@ -181,7 +181,7 @@ static int kobject_add_internal(struct k
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: parent: '%s', set: '%s'\n",
-		 kobject_name(kobj), kobj, __FUNCTION__,
+		 kobject_name(kobj), kobj, __func__,
 		 parent ? kobject_name(parent) : "<NULL>",
 		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>");
 
@@ -196,10 +196,10 @@ static int kobject_add_internal(struct k
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
@@ -540,7 +540,7 @@ static void kobject_cleanup(struct kobje
 	const char *name = kobj->name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
@@ -600,7 +600,7 @@ void kobject_put(struct kobject *kobj)
 
 static void dynamic_kobj_release(struct kobject *kobj)
 {
-	pr_debug("kobject: (%p): %s\n", kobj, __FUNCTION__);
+	pr_debug("kobject: (%p): %s\n", kobj, __func__);
 	kfree(kobj);
 }
 
@@ -657,7 +657,7 @@ struct kobject *kobject_create_and_add(c
 	retval = kobject_add(kobj, parent, "%s", name);
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
-		       __FUNCTION__, retval);
+		       __func__, retval);
 		kobject_put(kobj);
 		kobj = NULL;
 	}
@@ -765,7 +765,7 @@ static void kset_release(struct kobject 
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
@@ -101,7 +101,7 @@ int kobject_uevent_env(struct kobject *k
 	int retval = 0;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
@@ -111,7 +111,7 @@ int kobject_uevent_env(struct kobject *k
 	if (!top_kobj->kset) {
 		pr_debug("kobject: '%s' (%p): %s: attempted to send uevent "
 			 "without kset!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return -EINVAL;
 	}
 
@@ -123,7 +123,7 @@ int kobject_uevent_env(struct kobject *k
 		if (!uevent_ops->filter(kset, kobj)) {
 			pr_debug("kobject: '%s' (%p): %s: filter function "
 				 "caused the event to drop!\n",
-				 kobject_name(kobj), kobj, __FUNCTION__);
+				 kobject_name(kobj), kobj, __func__);
 			return 0;
 		}
 
@@ -135,7 +135,7 @@ int kobject_uevent_env(struct kobject *k
 	if (!subsystem) {
 		pr_debug("kobject: '%s' (%p): %s: unset subsystem caused the "
 			 "event to drop!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return 0;
 	}
 
@@ -177,7 +177,7 @@ int kobject_uevent_env(struct kobject *k
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
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

