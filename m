Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E814C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A4D207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266300;
	bh=Ow6tMXcp+Pi5GyOJgxxhJfPlE4wRpIcbdMUgwPsNu9g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vSEzst3bgodtph9/K+WUVDK2JM+JhBvDBFzf+Ii+IMz5FAHCUC5R41mUsLMQjDUOi
	 wsyL8Dr63QiCpxnqe7BtNcdP+yb3WNqwtH+yZCmrS9AlXtrUsGHx7C+Esxz2HfAmVK
	 CcZEhNpsR2hPXuJ3z+SckcN3r5NOuDvkE49e+hJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHLVE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgHLVE7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C1120774;
        Wed, 12 Aug 2020 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266298;
        bh=Ow6tMXcp+Pi5GyOJgxxhJfPlE4wRpIcbdMUgwPsNu9g=;
        h=Date:From:To:Subject:From;
        b=BU8wiLFd7ZxdnjDs/RVQZr7jSkItU8+3ihYjLDnArwaxsu3/NPJWXcbj4csdDSp3l
         t5uXq7rzbWQBpKUOaDdENbE86qet0Iq0YZ7WG3XeFAney626KS7ARMBEHbQTsEJLOj
         RM65cRWJUqUlatlNSH97FRBme+YFzceEpyznKhCw=
Date:   Wed, 12 Aug 2020 14:04:58 -0700
From:   akpm@linux-foundation.org
To:     grandmaster@al2klimov.de, hirofumi@mail.parknet.co.jp,
        mm-commits@vger.kernel.org
Subject:  [merged]
 vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch removed
 from -mm tree
Message-ID: <20200812210458.FYNbRbdgX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: VFAT/FAT/MSDOS FILESYSTEM: replace HTTP links with HTTPS ones
has been removed from the -mm tree.  Its filename was
     vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from grandmaster@al2klimov.de are


