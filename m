Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935E2C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiAVBUV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:20:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39002 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:20:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 025D1CE2508
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54651C340E1;
        Sat, 22 Jan 2022 01:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814417;
        bh=XhOTn/22Rcxj9i1gGRWYgrFS1V0MyUj3cj9ITXuiuvo=;
        h=Date:From:To:Subject:From;
        b=KuKCo/UYZWbELo0VW9LHg44C0M++6ZgGIk0rEAgqaluh8A3fplOrNHPH4iFWnMj7j
         hATWVG8ipy7jgw9xtx7ydC2Ts5e3zI5crAva9YHwbPCP1aFO82iwXi4dwuHHdT4rOS
         /WwBWjRWg/Hie+Lf25lwBHZLGkm7zEtK08qi9faM=
Date:   Fri, 21 Jan 2022 17:20:16 -0800
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?sysctl-add-and-use-base-directory-declarer-and-registration-?=
 =?US-ASCII?Q?helper-fix.patch?= removed from -mm tree
Message-ID: <20220122012016.xzRPW8alF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix
has been removed from the -mm tree.  Its filename was
     sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch

This patch was dropped because it was folded into sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch

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

hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
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
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

