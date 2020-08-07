Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D139C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F64221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781088;
	bh=inwxXJOzW583L1TEnOmq/+82ALgllUdI9JsbQA1l81U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NV9sA5hvQiZHI1kg+4Ei9hOTCNHkfMPBXLk+I9cwo823DZ1jcnw36QsAu57kf+6jn
	 BMcCmmeBQJXZ9eFBl3o70r570Cz/iUtBSmdRV/3i7LKLCoR9L3tFOqE/3Pr4YDDQOh
	 3hQQvUGDeNxX7oZ8zNlA1+qAu9gMQk7jz+5sdysU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGSI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B449D22CAF;
        Fri,  7 Aug 2020 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781087;
        bh=inwxXJOzW583L1TEnOmq/+82ALgllUdI9JsbQA1l81U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m644SMHR10wQKU+cYSNoMEdqdoZM80D1RU/8k0tMoEA9zevo+gNWwTf0SuTwhjKM+
         +0u+tA0Bo+jjhOwqeXTrNoK3VhpskHIW2OHCNIwrcGIyr6bNYJAaIpS47Io0hJ+jgO
         6bcoeNANxTznKc6cC8D4orTo+v+TxUyR1ynnWXsk=
Date:   Thu, 06 Aug 2020 23:18:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        grandmaster@al2klimov.de, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 020/163] ocfs2: replace HTTP links with HTTPS ones
Message-ID: <20200807061806.uYzfSKgwM%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
