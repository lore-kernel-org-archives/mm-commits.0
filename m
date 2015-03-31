From: akpm@linux-foundation.org
Subject: + dmapool-declare-struct-device.patch added to -mm tree
Date: Tue, 31 Mar 2015 13:08:55 -0700
Message-ID: <551afed7.Ac25C1/jZuxIgc+U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbbCaUI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 16:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dmapool.h: declare struct device
has been added to the -mm tree.  Its filename is
     dmapool-declare-struct-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dmapool-declare-struct-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dmapool-declare-struct-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: include/linux/dmapool.h: declare struct device

dmapool uses struct device in function arguments but relies on an implicit
inclusion to declare struct device causing warnings in some
configurations:

include/linux/dmapool.h:31:7: warning: 'struct device' declared inside parameter list

Fix this by adding a struct device declaration to the file.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dmapool.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/dmapool.h~dmapool-declare-struct-device include/linux/dmapool.h
--- a/include/linux/dmapool.h~dmapool-declare-struct-device
+++ a/include/linux/dmapool.h
@@ -14,6 +14,8 @@
 #include <asm/io.h>
 #include <asm/scatterlist.h>
 
+struct device;
+
 struct dma_pool *dma_pool_create(const char *name, struct device *dev, 
 			size_t size, size_t align, size_t allocation);
 
_

Patches currently in -mm which might be from broonie@kernel.org are

dmapool-declare-struct-device.patch
asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch
linux-next.patch
documentation-spi-spidev_testc-fix-warning.patch

