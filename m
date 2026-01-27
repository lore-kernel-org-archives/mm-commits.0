Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B6A3168EB
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486619; cv=none; b=k6XfIxr8QNvyldNieD42n4lsNoQ4v9OrKIunUeoDurO0EA8EySPv95nF9/V+qp5Kpj4Dg4LwTZT/UVnNsQyGXkhSNt7DrtJyc2J+mluvAob92g4Pi9/YKXOXhHGIsnIC+k7nozDxXyrbQ0P70xsegD2PEwBJTCvICZqZ9gTNoms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486619; c=relaxed/simple;
	bh=fVOI+39CcwvCmqc4EpT1bfYCNUtulQXX5+VBwQcuYa8=;
	h=Date:To:From:Subject:Message-Id; b=CaiyMNUSkhlaOjAuuXGw13MkNBt0BtmApe68CG0Lg8UjWkdmNFIfcy/hebCQuIsNILEhndYtETdGbfRYLySWVqKyB6M+TUmoef+77O1rBnkke0KoUQHNgwRXpxrMF2SdAPbw6mpl9Ha8DKIjzCPbJQs7+yuOPAfZJW88zUGL+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftv6PuYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftv6PuYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B25C116C6;
	Tue, 27 Jan 2026 04:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486618;
	bh=fVOI+39CcwvCmqc4EpT1bfYCNUtulQXX5+VBwQcuYa8=;
	h=Date:To:From:Subject:From;
	b=ftv6PuYUVTiGP4rJUuMMqhSEbN862hkHvIiiSWif82Ay/FBWZNdIRgdR6ZZ68PgQx
	 NUHlUEKRndqIAeGNa162ed8+lQ/GJiOsnGoC5pISbPuKpzyClJg8UI5KqHS6gPaf4I
	 rTFwOefp5sdjpNLpkyZqb4Br9OMY1zJU1leIdYEw=
Date: Mon, 26 Jan 2026 20:03:38 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,shorne@gmail.com,ritesh.list@gmail.com,richard@nod.at,pratyush@kernel.org,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,liam.howlett@oracle.com,klarasmodin@gmail.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,alexs@kernel.org,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] openrisc-introduce-arch_zone_limits_init.patch removed from -mm tree
Message-Id: <20260127040338.C3B25C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: openrisc: introduce arch_zone_limits_init()
has been removed from the -mm tree.  Its filename was
     openrisc-introduce-arch_zone_limits_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: openrisc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:47 +0200

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Link: https://lkml.kernel.org/r/20260111082105.290734-14-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/mm/init.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/openrisc/mm/init.c~openrisc-introduce-arch_zone_limits_init
+++ a/arch/openrisc/mm/init.c
@@ -39,15 +39,19 @@
 
 int mem_init_done;
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
-
 	/*
 	 * We use only ZONE_NORMAL
 	 */
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+static void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-cleanup-error-handling-in-kho_populate.patch

