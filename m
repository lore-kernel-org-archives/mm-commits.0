Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C292C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 481D82074F
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595880320;
	bh=Jwn7LCV3OOymWVHlgeXQDXxlaGUxAmjLqG6UjS55nLU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UHGmZVeigVwez6SgBB6EMdSoD2o+5JioBYM/G7X4FkUXcLNlgetiJ3zAj7zQfAMdv
	 GoyD5DZAbrxiYG7/JyzzsbYojlTpXaKXySerltv3XEfsU265hdfDh5HKRLsTWI+8m3
	 nXVRgsGjUJfU2qrBCF0xweYkK12K+SuEIdTcO/5w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgG0UFU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgG0UFT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:05:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B165F20729;
        Mon, 27 Jul 2020 20:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595880319;
        bh=Jwn7LCV3OOymWVHlgeXQDXxlaGUxAmjLqG6UjS55nLU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gMwEvnDzmZa3xRHZKhvRP0jOH38WEuHbe0jkbJe99Wj0GDOoJIDprCJbNuNwj/EYe
         VNFFhUqM2HDG92+VRtOBzqpyy3/BdxbB9LorQB8q7A/iQk4PXapw7D1HSJWWk9Hnc/
         /9Y15J2dc1JtTW9/ct5kmC88B5GqyMglNJ42JCho=
Date:   Mon, 27 Jul 2020 13:05:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gechangwei@live.cn, ghe@suse.com, grandmaster@al2klimov.de,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  + ocfs2-replace-http-links-with-https-ones.patch added to
 -mm tree
Message-ID: <20200727200518.nynsYZJSb%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace HTTP links with HTTPS ones
has been added to the -mm tree.  Its filename is
     ocfs2-replace-http-links-with-https-ones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-replace-http-links-with-https-ones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-replace-http-links-with-https-ones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: ocfs2: replace HTTP links with HTTPS ones

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `xmlns`:
        For each link, `http://[^# 	]*(?:\w|/)`:
	  If neither `gnu\.org/license`, nor `mozilla\.org/MPL`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Link: http://lkml.kernel.org/r/20200713174456.36596-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dlmfs.rst |    2 +-
 Documentation/filesystems/ocfs2.rst |    2 +-
 fs/ocfs2/Kconfig                    |    6 +++---
 fs/ocfs2/blockcheck.c               |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/filesystems/dlmfs.rst~ocfs2-replace-http-links-with-https-ones
+++ a/Documentation/filesystems/dlmfs.rst
@@ -12,7 +12,7 @@ dlmfs is built with OCFS2 as it requires
 
 :Project web page:    http://ocfs2.wiki.kernel.org
 :Tools web page:      https://github.com/markfasheh/ocfs2-tools
-:OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
+:OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
 
--- a/Documentation/filesystems/ocfs2.rst~ocfs2-replace-http-links-with-https-ones
+++ a/Documentation/filesystems/ocfs2.rst
@@ -14,7 +14,7 @@ get "mount.ocfs2" and "ocfs2_hb_ctl".
 
 Project web page:    http://ocfs2.wiki.kernel.org
 Tools git tree:      https://github.com/markfasheh/ocfs2-tools
-OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
+OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
 
--- a/fs/ocfs2/blockcheck.c~ocfs2-replace-http-links-with-https-ones
+++ a/fs/ocfs2/blockcheck.c
@@ -124,7 +124,7 @@ u32 ocfs2_hamming_encode(u32 parity, voi
 		 * parity bits that are part of the bit number
 		 * representation.  Huh?
 		 *
-		 * <wikipedia href="http://en.wikipedia.org/wiki/Hamming_code">
+		 * <wikipedia href="https://en.wikipedia.org/wiki/Hamming_code">
 		 * In other words, the parity bit at position 2^k
 		 * checks bits in positions having bit k set in
 		 * their binary representation.  Conversely, for
--- a/fs/ocfs2/Kconfig~ocfs2-replace-http-links-with-https-ones
+++ a/fs/ocfs2/Kconfig
@@ -16,9 +16,9 @@ config OCFS2_FS
 	  You'll want to install the ocfs2-tools package in order to at least
 	  get "mount.ocfs2".
 
-	  Project web page:    http://oss.oracle.com/projects/ocfs2
-	  Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
-	  OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
+	  Project web page:    https://oss.oracle.com/projects/ocfs2
+	  Tools web page:      https://oss.oracle.com/projects/ocfs2-tools
+	  OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
 
 	  For more information on OCFS2, see the file
 	  <file:Documentation/filesystems/ocfs2.rst>.
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

ocfs2-replace-http-links-with-https-ones.patch
mm-thp-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

