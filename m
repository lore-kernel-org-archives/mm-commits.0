Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C48C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 22:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbhLAWPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 17:15:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52336 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242357AbhLAWPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 17:15:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD09B82157
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 22:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66342C53FCC;
        Wed,  1 Dec 2021 22:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638396739;
        bh=w+vGdXfPTDMB6TfLvglNWhYFv+/XpjySc6yr1rn3tFQ=;
        h=Date:From:To:Subject:From;
        b=wkFRfuTkEWYyZKteB30l5z4g+nMmsglp0cCAtWJI5DzW3dFYTjxpvAr4kXZlQ1XNs
         g86T8Gu9RY/WI4U+HqDCpyTASnJ4I2hAQ4OXkbS0+bXINgNL3Q4BEttawNfi7SRYrC
         pw9x7rMxqxuWmhzIVifRaGEMU9SC5EdtTUHIwB8s=
Date:   Wed, 01 Dec 2021 14:12:18 -0800
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?sysctl-add-and-use-base-directory-declarer-and-registration-?=
 =?US-ASCII?Q?helper-fix.patch?= added to -mm tree
Message-ID: <20211201221218.eyl16t9UL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix
has been added to the -mm tree.  Its filename is
     sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix

null-terminate the ctl_table arrays

Link: https://lkml.kernel.org/r/YafJY3rXDYnjK/gs@bombadil.infradead.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/sysctl.h~sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix
+++ a/include/linux/sysctl.h
@@ -201,6 +201,7 @@ static struct ctl_table _name##_base_tab
 		.mode		= 0555,					\
 		.child		= _table,				\
 	},								\
+	{ },								\
 }
 
 extern int __register_sysctl_base(struct ctl_table *base_table);
_

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
sysctl-add-helper-to-register-a-sysctl-mount-point.patch
fs-move-binfmt_misc-sysctl-to-its-own-file.patch
sysctl-share-unsigned-long-const-values.patch
fs-move-inode-sysctls-to-its-own-file.patch
fs-move-fs-stat-sysctls-to-file_tablec.patch
fs-move-dcache-sysctls-to-its-own-file.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
fs-move-shared-sysctls-to-fs-sysctlsc.patch
fs-move-locking-sysctls-where-they-are-used.patch
fs-move-namei-sysctls-to-its-own-file.patch
fs-move-fs-execc-sysctls-into-its-own-file.patch
fs-move-pipe-sysctls-to-is-own-file.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

