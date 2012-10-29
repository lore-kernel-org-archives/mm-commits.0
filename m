From: akpm@linux-foundation.org
Subject: [merged] device_cgroup-rename-deny_all-to-behavior.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:41 -0700
Message-ID: <20121029194941.B4FA01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53197 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2J2Ttn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:43 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so682958ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, davej@redhat.com, jmorris@namei.org, jslaby@suse.cz, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device_cgroup: rename deny_all to behavior
has been removed from the -mm tree.  Its filename was
     device_cgroup-rename-deny_all-to-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: rename deny_all to behavior

This was done in a v2 patch but v1 ended up being committed.  The variable
name is less confusing and stores the default behavior when no matching
exception exists.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-rename-deny_all-to-behavior security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-rename-deny_all-to-behavior
+++ a/security/device_cgroup.c
@@ -42,7 +42,10 @@ struct dev_exception_item {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head exceptions;
-	bool deny_all;
+	enum {
+		DEVCG_DEFAULT_ALLOW,
+		DEVCG_DEFAULT_DENY,
+	} behavior;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -182,13 +185,13 @@ static struct cgroup_subsys_state *devcg
 	parent_cgroup = cgroup->parent;
 
 	if (parent_cgroup == NULL)
-		dev_cgroup->deny_all = false;
+		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
 	else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
 					  &parent_dev_cgroup->exceptions);
-		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
+		dev_cgroup->behavior = parent_dev_cgroup->behavior;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -260,7 +263,7 @@ static int devcgroup_seq_read(struct cgr
 	 * - List the exceptions in case the default policy is to deny
 	 * This way, the file remains as a "whitelist of devices"
 	 */
-	if (devcgroup->deny_all == false) {
+	if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 		set_access(acc, ACC_MASK);
 		set_majmin(maj, ~0);
 		set_majmin(min, ~0);
@@ -314,12 +317,12 @@ static int may_access(struct dev_cgroup 
 	 * In two cases we'll consider this new exception valid:
 	 * - the dev cgroup has its default policy to allow + exception list:
 	 *   the new exception should *not* match any of the exceptions
-	 *   (!deny_all, !match)
+	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (deny_all, match)
+	 *   (behavior == DEVCG_DEFAULT_DENY, match)
 	 */
-	if (dev_cgroup->deny_all == match)
+	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
 		return 1;
 	return 0;
 }
@@ -375,11 +378,11 @@ static int devcgroup_update_access(struc
 			if (!parent_has_perm(devcgroup, &ex))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = false;
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = true;
+			devcgroup->behavior = DEVCG_DEFAULT_DENY;
 			break;
 		default:
 			return -EINVAL;
@@ -452,7 +455,7 @@ static int devcgroup_update_access(struc
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == false) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
@@ -463,7 +466,7 @@ static int devcgroup_update_access(struc
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == true) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
_

Patches currently in -mm which might be from aris@redhat.com are

linux-next.patch

