Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CD6C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 19:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiD0TZp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiD0TYE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 15:24:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F681ABF6E
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 12:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06A72B82929
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 19:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB8C385A7;
        Wed, 27 Apr 2022 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651087143;
        bh=tuRlikfHp8S0zcRovmJIMUrIH1GgBLqfEj0OgjybLso=;
        h=Date:To:From:Subject:From;
        b=abmnJynAq5ybdjETudfEvB2p1q+n23xB4Ze9hVAMjSeFfBnz2JRrWApumYIh2WAZf
         fBnsalmu3iZNFaypIDuUwApGxKhpF8GdsXZm3wAPeX5r5bPfDg6XV/eQHhkESgRUqO
         MgYQKYzA9XtdwRehlYI1fpwR0fhTkv0FEorMiqq4=
Date:   Wed, 27 Apr 2022 12:19:02 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch added to -mm tree
Message-Id: <20220427191903.ADDB8C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: register a damon_operations for fixed virtual address ranges monitoring
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: register a damon_operations for fixed virtual address ranges monitoring

Patch series "support fixed virtual address ranges monitoring".

The monitoring operations set for virtual address spaces automatically
updates the monitoring target regions to cover entire mappings of the
virtual address spaces as much as possible.  Some users could have more
information about their programs than kernel and therefore have interest
in not entire regions but only specific regions.  For such cases, the
automatic monitoring target regions updates are only unnecessary overhead
or distractions.

This patchset adds supports for the use case on DAMON's kernel API
(DAMON_OPS_FVADDR) and sysfs interface ('fvaddr' keyword for 'operations'
sysfs file).


This patch (of 3):

The monitoring operations set for virtual address spaces automatically
updates the monitoring target regions to cover entire mappings of the
virtual address spaces as much as possible.  Some users could have more
information about their programs than kernel and therefore have interest
in not entire regions but only specific regions.  For such cases, the
automatic monitoring target regions updates are only unnecessary overheads
or distractions.

For such cases, DAMON's API users can simply set the '->init()' and
'->update()' of the DAMON context's '->ops' NULL, and set the target
monitoring regions when creating the context.  But, that would be a dirty
hack.  Worse yet, the hack is unavailable for DAMON user space interface
users.

To support the use case in a clean way that can easily exported to the
user space, this commit adds another monitoring operations set called
'fvaddr', which is same to 'vaddr' but does not automatically update the
monitoring regions.  Instead, it will only respect the virtual address
regions which have explicitly passed at the initial context creation.

Note that this commit leave sysfs interface not supporting the feature
yet.  The support will be made in a following commit.

Link: https://lkml.kernel.org/r/20220426231750.48822-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220426231750.48822-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 mm/damon/sysfs.c      |    4 ++++
 mm/damon/vaddr.c      |   13 ++++++++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring
+++ a/include/linux/damon.h
@@ -261,10 +261,13 @@ struct damos {
  * enum damon_ops_id - Identifier for each monitoring operations implementation
  *
  * @DAMON_OPS_VADDR:	Monitoring operations for virtual address spaces
+ * @DAMON_OPS_FVADDR:	Monitoring operations for only fixed ranges of virtual
+ *			address spaces
  * @DAMON_OPS_PADDR:	Monitoring operations for the physical address space
  */
 enum damon_ops_id {
 	DAMON_OPS_VADDR,
+	DAMON_OPS_FVADDR,
 	DAMON_OPS_PADDR,
 	NR_DAMON_OPS,
 };
--- a/mm/damon/sysfs.c~mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring
+++ a/mm/damon/sysfs.c
@@ -1694,6 +1694,7 @@ static struct kobj_type damon_sysfs_attr
 /* This should match with enum damon_ops_id */
 static const char * const damon_sysfs_ops_strs[] = {
 	"vaddr",
+	"unsupported",	/* fvaddr is not supported by sysfs yet */
 	"paddr",
 };
 
@@ -1843,6 +1844,9 @@ static ssize_t operations_store(struct k
 
 	for (id = 0; id < NR_DAMON_OPS; id++) {
 		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
+			/* fvaddr is not supported by sysfs yet */
+			if (id == DAMON_OPS_FVADDR)
+				return -EINVAL;
 			context->ops_id = id;
 			return count;
 		}
--- a/mm/damon/vaddr.c~mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring
+++ a/mm/damon/vaddr.c
@@ -754,8 +754,19 @@ static int __init damon_va_initcall(void
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
 	};
+	/* ops for fixed virtual address ranges */
+	struct damon_operations ops_fvaddr = ops;
+	int err;
 
-	return damon_register_ops(&ops);
+	/* Don't set the monitoring target regions for the entire mapping */
+	ops_fvaddr.id = DAMON_OPS_FVADDR;
+	ops_fvaddr.init = NULL;
+	ops_fvaddr.update = NULL;
+
+	err = damon_register_ops(&ops);
+	if (err)
+		return err;
+	return damon_register_ops(&ops_fvaddr);
 };
 
 subsys_initcall(damon_va_initcall);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch

