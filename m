Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFE6C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E81420658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196160;
	bh=MQMIOTR8q3EHIhGQ0KufveJ/E3+Z2B0+feOG8odXVrQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2kZSaN5ERGR0VxKAxpkLMKTW2YNycvrk4LhWUoHGvHQNIZamr8tSxPH+/bXoviPY5
	 xz7EVa002auwPsb2X1mvJGBWtcM0GHykYG3NtvlTKWh8AlNQiiz+ibKqy61aI97eLw
	 rso6PMAWdrmxQGGJ/Aeh+GpF2AwAkRkWO5m7uUso=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLBgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D632054F;
        Wed, 12 Aug 2020 01:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196159;
        bh=MQMIOTR8q3EHIhGQ0KufveJ/E3+Z2B0+feOG8odXVrQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IfQ73xRxJXbCJTyxGPUskOdX7myCX8sQbrGNq19e8sGJVDvHC6Um21eB2NSAEbz2p
         QQW+HvIc6AwvkYGKD6cJZaUUnRPbpqi3JS+vuWRsoSGg8/O9usZ8UvS/ebV2BZtTWt
         iottOWT0QvdcPktQnaqOsODYvIncGsrq45PE048Q=
Date:   Tue, 11 Aug 2020 18:35:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        hirofumi@mail.parknet.co.jp, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 109/165] VFAT/FAT/MSDOS FILESYSTEM: replace HTTP
 links with HTTPS ones
Message-ID: <20200812013559.qFCfKIMLV%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: VFAT/FAT/MSDOS FILESYSTEM: replace HTTP links with HTTPS ones

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

Link: http://lkml.kernel.org/r/20200708200409.22293-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/Kconfig~vfat-fat-msdos-filesystem-replace-http-links-with-https-ones
+++ a/fs/fat/Kconfig
@@ -41,7 +41,7 @@ config MSDOS_FS
 	  they are compressed; to access compressed MSDOS partitions under
 	  Linux, you can either use the DOS emulator DOSEMU, described in the
 	  DOSEMU-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, or try dmsdosfs in
+	  <https://www.tldp.org/docs.html#howto>, or try dmsdosfs in
 	  <ftp://ibiblio.org/pub/Linux/system/filesystems/dosfs/>. If you
 	  intend to use dosemu with a non-compressed MSDOS partition, say Y
 	  here) and MSDOS floppies. This means that file access becomes
_
