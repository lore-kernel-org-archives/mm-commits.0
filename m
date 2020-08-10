Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C52C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1052075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026869;
	bh=8MRLqAnX5JsWb86GfHd2ZJEXI4sBei+GEy1d4m2MS2c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZYgQejVUyHTMPQrTioFTvWttS9Wxrgw/qpo0pl9PTAnVtzSbLYADwH3fgL/SYdIv8
	 QxrVWy3HdaUyp0u7QlJxEk1PXMQjX2/Ku/SenmEW+oTIx84t6aom6zm0YDnV/lv1hr
	 79ddyPRiKkTx14nnSxGQKtFboGs2js+LGgL7m+XA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCe3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A8C20723;
        Mon, 10 Aug 2020 02:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026868;
        bh=8MRLqAnX5JsWb86GfHd2ZJEXI4sBei+GEy1d4m2MS2c=;
        h=Date:From:To:Subject:From;
        b=EgFMT4tD00bgUyVxGON4QFOvKhhWgrmHF2GDD2DAB9xrsobjG3urhEodx7+cyPkmG
         g1sIvgCgVN6Qnn0dDvw68lkQbKBVZfTITicgWPmVoIT+Z8yY74ROx8/Xu9WB2kcMAR
         R/GRYMC9aYOKfsCSH1sjSh1x+20kYQYbnbCv5ZyI=
Date:   Sun, 09 Aug 2020 19:34:28 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, grandmaster@al2klimov.de,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged] ocfs2-replace-http-links-with-https-ones.patch
 removed from -mm tree
Message-ID: <20200810023428.pOlr2h8_P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace HTTP links with HTTPS ones
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-http-links-with-https-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

include-replace-http-links-with-https-ones.patch
lib-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

