From: akpm@linux-foundation.org
Subject: [merged] thermal_sys-remove-unnecessary-line-continuations.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:39 -0700
Message-ID: <20120323182239.5AAA0A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44298 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab2CWSWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:41 -0400
Received: by faaa19 with SMTP id a19so193216faa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jj@chaosbits.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal_sys: remove unnecessary line continuations
has been removed from the -mm tree.  Its filename was
     thermal_sys-remove-unnecessary-line-continuations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: thermal_sys: remove unnecessary line continuations

Line continations are not necessary in function calls or statements. 
Remove them.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-remove-unnecessary-line-continuations drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-remove-unnecessary-line-continuations
+++ a/drivers/thermal/thermal_sys.c
@@ -281,8 +281,7 @@ passive_show(struct device *dev, struct 
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
-static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, \
-		   passive_store);
+static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 
 static struct device_attribute trip_point_attrs[] = {
 	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
@@ -1313,8 +1312,8 @@ int thermal_generate_netlink_event(u32 o
 	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
-	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
-				nla_total_size(0);
+	size = nla_total_size(sizeof(struct thermal_genl_event)) +
+	       nla_total_size(0);
 
 	skb = genlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
@@ -1330,8 +1329,8 @@ int thermal_generate_netlink_event(u32 o
 	}
 
 	/* fill the data */
-	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT, \
-			sizeof(struct thermal_genl_event));
+	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT,
+			   sizeof(struct thermal_genl_event));
 
 	if (!attr) {
 		nlmsg_free(skb);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
get_maintainerpl-add-support-for-moderated-lists.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

