Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE08A134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710533; cv=none; b=IXBpya/QkfTx2alUtLZkSsy18F64+Ipnt1v4IicxTWi8ti5NvTPQY/L3xWpIlmjXwWTj5yGj/JDNd+AqUWrbE0VDYxUfXGQbqglp7TE5pDw3GBmfTMCVzJ9VjV43CtTYTIQeiq1JPHtkr6J5uIflDyC0fLpgNQTZpAvuqs3bTBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710533; c=relaxed/simple;
	bh=DQ3tCMgIqICSVypklpxoU2AcQRcUKgeBJ+pzj39S7so=;
	h=Date:To:From:Subject:Message-Id; b=oYE6Yy+WWHbMivRDPGZ8qU7RC0v4F/GrQ4XRBeUUePGqcSmMkRY6Y9CagBPPo0giV3a2q5AwPo71ofp508pc+i8WvNBhnozSaUOuEQxxZBXiHT8rSpd7X5rhaVERfMn03IiabhmoMMbVaOyrnX1pSeIZ6WfoVxi4FR1vamu0T6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUcKDqqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUcKDqqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9F9C116B1;
	Sat,  3 Aug 2024 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710533;
	bh=DQ3tCMgIqICSVypklpxoU2AcQRcUKgeBJ+pzj39S7so=;
	h=Date:To:From:Subject:From;
	b=nUcKDqqJ0EuNy+3J7vAuhH/SM///S8qIzvfx+hIzPNO6DfjJQaMfLR/8JooUz4x6j
	 E3rhJ3ST1lt3HuMGHSzMFbLcHcC7aNVOY1JF5RIoLXWhP3yc75QVBKv8Ao60yg9hbA
	 qESIyzNrnLVdazZG2Ph/PuEEJHFLKL+oVrDnEadA=
Date: Sat, 03 Aug 2024 11:42:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,rppt@kernel.org,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-config_have_arch_nodedata_extension-fix.patch added to mm-unstable branch
Message-Id: <20240803184213.AC9F9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-drop-config_have_arch_nodedata_extension-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-config_have_arch_nodedata_extension-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-config_have_arch_nodedata_extension-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-config_have_arch_nodedata_extension-fix
Date: Sat Aug  3 11:33:02 AM PDT 2024

install pgdat into node_data[] for offline nodes, per Jonathan

Link: https://lkml.kernel.org/r/20240802104922.000051a0@Huawei.com
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mm_init.c~mm-drop-config_have_arch_nodedata_extension-fix
+++ a/mm/mm_init.c
@@ -1842,6 +1842,7 @@ void __init free_area_init(unsigned long
 			if (!pgdat)
 				panic("Cannot allocate %zuB for node %d.\n",
 				       sizeof(*pgdat), nid);
+			NODE_DATA(nid) = pgdat;
 		}
 
 		pgdat = NODE_DATA(nid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-drop-config_have_arch_nodedata_extension-fix.patch

