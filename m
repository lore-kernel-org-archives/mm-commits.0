From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 039/127] sparc: remove unnecessary includes
Date: Thu, 04 Jun 2020 16:48:14 -0700
Message-ID: <20200604234814.0ypwn1HTG%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:15 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: sparc: remove unnecessary includes

linux/highmem.h has not been needed for the pte_offset_map =3D> kmap_atomic
use in sparc for some time (~2002)

Remove this include.

Link: http://lkml.kernel.org/r/20200507150004.1423069-15-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/io-unit.c |    1 -
 arch/sparc/mm/iommu.c   |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/sparc/mm/iommu.c~sparc-remove-unnecessary-includes
+++ a/arch/sparc/mm/iommu.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>	/* pte_offset_map =3D> kmap_atomic */
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
--- a/arch/sparc/mm/io-unit.c~sparc-remove-unnecessary-includes
+++ a/arch/sparc/mm/io-unit.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>	/* pte_offset_map =3D> kmap_atomic */
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
_
