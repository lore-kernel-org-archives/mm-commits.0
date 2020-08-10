Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF0CC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E008E20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027225;
	bh=bbBk97W4yVfQplAtZlNkBRpyOIRqA943ttnKiimkr2o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MmsxEO87hDDi+iVs0IjUlj4RxVTVYoZtVSHdexN2gyhfVei40+yRTm9muKjP3ORYR
	 jexp22wdvlKduaSfgcZ0P/EFGDherHk85VbTVe1T9ZljeVzfR80CF4qyedaGiQIYl0
	 KgDDrLq4f5CnfqY9KY2F5xHFtZukKGqT7enrGbHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgHJCkZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972D5206CD;
        Mon, 10 Aug 2020 02:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027223;
        bh=bbBk97W4yVfQplAtZlNkBRpyOIRqA943ttnKiimkr2o=;
        h=Date:From:To:Subject:From;
        b=C/Kp3cQzzKPkqbAZMOAwe4jylSdAb4AcDd33rhdgY1h2/Ly1GMvIs5mgHNzbGQUeM
         HdzELP4c/+d4B+ad77kkdpod81qjN5N03uy1SyjXed5+bzvwEKr0hCefru5QarujNr
         ycggC2tqQ/gN6f28YSbe9yOSSeo6jKGhTu4Chi+o=
Date:   Sun, 09 Aug 2020 19:40:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged] mm-thp-replace-http-links-with-https-ones.patch
 removed from -mm tree
Message-ID: <20200810024023.t2hPzPUH1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: replace HTTP links with HTTPS ones
has been removed from the -mm tree.  Its filename was
     mm-thp-replace-http-links-with-https-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: mm: thp: replace HTTP links with HTTPS ones

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

[akpm@linux-foundation.org: fix amd.com URL, per Vlastimil]
Link: http://lkml.kernel.org/r/20200713164345.36088-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-http-links-with-https-ones
+++ a/mm/huge_memory.c
@@ -2063,8 +2063,8 @@ static void __split_huge_pmd_locked(stru
 	 * free), userland could trigger a small page size TLB miss on the
 	 * small sized TLB while the hugepage TLB entry is still established in
 	 * the huge TLB. Some CPU doesn't like that.
-	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
-	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * See http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum
+	 * 383 on page 105. Intel should be safe but is also warns that it's
 	 * only safe if the permission and cache attributes of the two entries
 	 * loaded in the two TLB is identical (which should be the case here).
 	 * But it is generally safer to never allow small and huge TLB entries
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

include-replace-http-links-with-https-ones.patch
lib-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

