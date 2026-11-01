Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565182;
	b=qAnxwG12JlEa2jaahySI5h85vfUuMH6NqaVkQ+Cllcj9488KiD2ncOJS0ZrxK4T6MXaH
	 SzG+cU2z4njm+L4lPkQq4ht7gOgE9tIPFlD7kohGHm6UFHKmSPxO3LMuRp9jgaEI7KRZu
	 hQ96IrjiLhijLM69agrPTvNHULk2L2ppt9o2jK0GUeoPHp6FrZn/DNXXfsNhX6Qu3BiJW
	 FhHaqRPov2JBRlQCRFMt1v+rFZ2QAPApia42Tkxhe7VJL1z41Zl5FVRA9Anmo7GvjKVIx
	 PnWGTKcD7dyt/uWDC0F1j2lzSamCR9MnEtFSHmAuIQc/YfgecSUKSSQ4gIqvjDn+73A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565182;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=u3wx7bU/x3yQXJ0ik1TRkJoZzT9X+SDWFCSfmoFgbAk=;
	b=P71u3Au6IKh4f3Z4iFEQ7k+UeobyP2B29NxUCGT57j5n3YePPHD3F+BQGUatAY1yniNr
	 XxODO1YdCHvkvP+OSEPm7a4eQdaP+/NZJYnWLxPOMwgcALs9AAsQthorigURu7P7e0bMe
	 XH5DeloToz9OHiTrlUnp6ZdA3424dQQfDl8XjltRvvA+cV014efszkd5NH0eja3BqJoc+
	 0YRVcNZ9KBlvIdeh5MJXq2pSC2L98aK7i3zt3xDTiWMOZqgka6ISG8SAlz0UO5mr8mmMo
	 RQdJwNTgFm9WGI58bS6c7abcbnznZk9TiD+l8yBCunWdZK4KEcFMKjRgrIJoU/LPDgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Cq/A3SDX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6447606A329
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cq/A3SDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AC41F00919;
	Sun,  1 Nov 2026 20:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565180;
	bh=u3wx7bU/x3yQXJ0ik1TRkJoZzT9X+SDWFCSfmoFgbAk=;
	h=Date:To:From:Subject;
	b=Cq/A3SDXDXaCSFzhoyGtIZUVU/K8K91R6FKezY0GgoXuu/Ltzr5WiEFmqKC38Wfv9
	 E6iyAiyUL2dcvqu0xcroe1gGjp+QAHaoHnxwt4sq00iS3iJBHuGLljLY6QLKfdz4ZH
	 4MMzTJPI4nH7T/Qe0aAGcY+LCr/ubl+hFpgnn39U=
Date: Sun, 01 Nov 2026 12:32:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,
	ying.huang@linux.alibaba.com,xu.xin@linux.dev,will@kernel.org,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tj@kernel.org,
	surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,
	shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,
	roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,
	rakie.kim@sk.com,qi.zheng@linux.dev,pfalcato@suse.de,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nphamcs@gmail.com,
	nico.pache@linux.dev,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mhocko@kernel.org,matthew.brost@intel.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,
	kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hughd@google.com,
	harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,gourry@gourry.net,
	dev.jain@arm.com,dennis@kernel.org,david@kernel.org,david@fromorbit.com,
	cl@gentwo.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,
	brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,apopple@nvidia.com,aneesh.kumar@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-sort-component-entries-alphabetically.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101203300.45AC41F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: sort component entries alphabetically
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-sort-component-entries-alphabetically.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-sort-component-entries-alphabetically.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: sort component entries alphabetically
Date: Sun, 01 Nov 2026 12:13:07 -0800

Sort the component entries alphabetically, keeping the introductory
text at the start and THE REST at the end.  This groups the renamed MM
entries together and corrects existing ordering inconsistencies.

Move complete entries without changing their contents or the order of
lines within them.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 MAINTAINERS | 3252 +++++++++++++++++++++++++-------------------------
 1 file changed, 1626 insertions(+), 1626 deletions(-)

--- a/MAINTAINERS~maintainers-sort-component-entries-alphabetically
+++ a/MAINTAINERS
@@ -429,6 +429,17 @@ S:	Maintained
 W:	https://parisc.wiki.kernel.org/index.php/AD1889
 F:	sound/pci/ad1889.*
 
+AD4030 ADC DRIVER (AD4030-24/AD4630-16/AD4630-24/AD4632-16/AD4632-24)
+M:	Michael Hennerich <michael.hennerich@analog.com>
+M:	Nuno Sá <nuno.sa@analog.com>
+R:	Esteban Blanc <eblanc@baylibre.com>
+L:	linux-iio@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/iio/adc/adi,ad4030.yaml
+F:	Documentation/iio/ad4030.rst
+F:	drivers/iio/adc/ad4030.c
+
 AD5110 ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Mugilraj Dhavachelvan <dmugil2000@gmail.com>
 L:	linux-iio@vger.kernel.org
@@ -1064,6 +1075,12 @@ L:	dmaengine@vger.kernel.org
 S:	Supported
 F:	drivers/dma/amd/ae4dma/
 
+AMD ASF I2C DRIVER
+M:	Shyam Sundar S K <shyam-sundar.s-k@amd.com>
+L:	linux-i2c@vger.kernel.org
+S:	Supported
+F:	drivers/i2c/busses/i2c-amd-asf-plat.c
+
 AMD ASoC DRIVERS
 M:	Vijendar Mukunda <Vijendar.Mukunda@amd.com>
 R:	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
@@ -1102,14 +1119,6 @@ S:	Supported
 F:	drivers/crypto/ccp/
 F:	include/linux/ccp.h
 
-AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
-M:	Ashish Kalra <ashish.kalra@amd.com>
-M:	Tom Lendacky <thomas.lendacky@amd.com>
-L:	linux-crypto@vger.kernel.org
-S:	Supported
-F:	drivers/crypto/ccp/sev*
-F:	include/uapi/linux/psp-sev.h
-
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DBC SUPPORT
 M:	Mario Limonciello <mario.limonciello@amd.com>
 L:	linux-crypto@vger.kernel.org
@@ -1128,6 +1137,14 @@ L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/ccp/hsti.*
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
+M:	Ashish Kalra <ashish.kalra@amd.com>
+M:	Tom Lendacky <thomas.lendacky@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/sev*
+F:	include/uapi/linux/psp-sev.h
+
 AMD DISPLAY CORE
 M:	Harry Wentland <harry.wentland@amd.com>
 M:	Leo Li <sunpeng.li@amd.com>
@@ -1179,6 +1196,15 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/amd/amd_halo_led.c
 
+AMD HETERO CORE HARDWARE FEEDBACK DRIVER
+M:	Mario Limonciello <mario.limonciello@amd.com>
+R:	Perry Yuan <perry.yuan@amd.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Supported
+B:	https://gitlab.freedesktop.org/drm/amd/-/issues
+F:	Documentation/arch/x86/amd-hfi.rst
+F:	drivers/platform/x86/amd/hfi/
+
 AMD HSMP DRIVER
 M:	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
 R:	Carlos Bilbao <carlos.bilbao@kernel.org>
@@ -1189,15 +1215,6 @@ F:	arch/x86/include/asm/amd/hsmp.h
 F:	arch/x86/include/uapi/asm/amd_hsmp.h
 F:	drivers/platform/x86/amd/hsmp/
 
-AMD HETERO CORE HARDWARE FEEDBACK DRIVER
-M:	Mario Limonciello <mario.limonciello@amd.com>
-R:	Perry Yuan <perry.yuan@amd.com>
-L:	platform-driver-x86@vger.kernel.org
-S:	Supported
-B:	https://gitlab.freedesktop.org/drm/amd/-/issues
-F:	Documentation/arch/x86/amd-hfi.rst
-F:	drivers/platform/x86/amd/hfi/
-
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel (AMD) <joro@8bytes.org>
 M:	Vasant Hegde <vasant.hegde@amd.com>
@@ -1254,12 +1271,6 @@ L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-amd-mp2*
 
-AMD ASF I2C DRIVER
-M:	Shyam Sundar S K <shyam-sundar.s-k@amd.com>
-L:	linux-i2c@vger.kernel.org
-S:	Supported
-F:	drivers/i2c/busses/i2c-amd-asf-plat.c
-
 AMD NODE DRIVER
 M:	Mario Limonciello <mario.limonciello@amd.com>
 M:	Yazen Ghannam <yazen.ghannam@amd.com>
@@ -1509,17 +1520,6 @@ F:	Documentation/devicetree/bindings/iio
 F:	Documentation/iio/ad4000.rst
 F:	drivers/iio/adc/ad4000.c
 
-AD4030 ADC DRIVER (AD4030-24/AD4630-16/AD4630-24/AD4632-16/AD4632-24)
-M:	Michael Hennerich <michael.hennerich@analog.com>
-M:	Nuno Sá <nuno.sa@analog.com>
-R:	Esteban Blanc <eblanc@baylibre.com>
-L:	linux-iio@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/iio/adc/adi,ad4030.yaml
-F:	Documentation/iio/ad4030.rst
-F:	drivers/iio/adc/ad4030.c
-
 ANALOG DEVICES INC AD4062 DRIVER
 M:	Jorge Marques <jorge.marques@analog.com>
 S:	Supported
@@ -1716,6 +1716,14 @@ W:	https://ez.analog.com/linux-software-
 F:	Documentation/devicetree/bindings/iio/amplifiers/adi,ad8366.yaml
 F:	drivers/iio/amplifiers/ad8366.c
 
+ANALOG DEVICES INC AD8460 DRIVER
+M:	Mariel Tinaco <Mariel.Tinaco@analog.com>
+L:	linux-iio@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/iio/dac/adi,ad8460.yaml
+F:	drivers/iio/dac/ad8460.c
+
 ANALOG DEVICES INC AD9467 DRIVER
 M:	Michael Hennerich <Michael.Hennerich@analog.com>
 M:	Nuno Sa <nuno.sa@analog.com>
@@ -1726,14 +1734,6 @@ F:	Documentation/ABI/testing/debugfs-iio
 F:	Documentation/devicetree/bindings/iio/adc/adi,ad9467.yaml
 F:	drivers/iio/adc/ad9467.c
 
-ANALOG DEVICES INC AD8460 DRIVER
-M:	Mariel Tinaco <Mariel.Tinaco@analog.com>
-L:	linux-iio@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/iio/dac/adi,ad8460.yaml
-F:	drivers/iio/dac/ad8460.c
-
 ANALOG DEVICES INC AD9739a DRIVER
 M:	Nuno Sa <nuno.sa@analog.com>
 M:	Dragos Bogdan <dragos.bogdan@analog.com>
@@ -1754,14 +1754,6 @@ F:	Documentation/devicetree/bindings/iio
 F:	Documentation/iio/ad9910.rst
 F:	drivers/iio/frequency/ad9910.c
 
-ANALOG DEVICES INC MAX22007 DRIVER
-M:	Janani Sunil <janani.sunil@analog.com>
-L:	linux-iio@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/iio/dac/adi,max22007.yaml
-F:	drivers/iio/dac/max22007.c
-
 ANALOG DEVICES INC ADA4250 DRIVER
 M:	Antoniu Miclaus <antoniu.miclaus@analog.com>
 L:	linux-iio@vger.kernel.org
@@ -2019,6 +2011,14 @@ F:	drivers/iio/amplifiers/hmc425a.c
 F:	drivers/staging/iio/*/ad*
 X:	drivers/iio/*/adjd*
 
+ANALOG DEVICES INC MAX22007 DRIVER
+M:	Janani Sunil <janani.sunil@analog.com>
+L:	linux-iio@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/iio/dac/adi,max22007.yaml
+F:	drivers/iio/dac/max22007.c
+
 ANALOGBITS PLL LIBRARIES
 M:	Paul Walmsley <pjw@kernel.org>
 M:	Samuel Holland <samuel.holland@sifive.com>
@@ -2069,6 +2069,20 @@ L:	linux-sound@vger.kernel.org
 S:	Maintained
 F:	sound/aoa/
 
+AOSONG ADP810 DIFFERENTIAL PRESSURE SENSOR DRIVER
+M:	Akhilesh Patil <akhilesh@ee.iitb.ac.in>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/iio/pressure/aosong,adp810.yaml
+F:	drivers/iio/pressure/adp810.c
+
+AOSONG AGS02MA TVOC SENSOR DRIVER
+M:	Anshul Dalal <anshulusr@gmail.com>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/iio/chemical/aosong,ags02ma.yaml
+F:	drivers/iio/chemical/ags02ma.c
+
 APEX EMBEDDED SYSTEMS STX104 IIO DRIVER
 M:	William Breathitt Gray <wbg@kernel.org>
 L:	linux-iio@vger.kernel.org
@@ -2341,19 +2355,6 @@ F:	Documentation/gpu/komeda-kms.rst
 F:	drivers/gpu/drm/arm/display/include/
 F:	drivers/gpu/drm/arm/display/komeda/
 
-ARM MALI PANFROST DRM DRIVER
-M:	Boris Brezillon <boris.brezillon@collabora.com>
-M:	Rob Herring <robh@kernel.org>
-M:	Steven Price <steven.price@arm.com>
-M:	Adrián Larumbe <adrian.larumbe@collabora.com>
-L:	dri-devel@lists.freedesktop.org
-S:	Supported
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/gpu/panfrost.rst
-F:	drivers/gpu/drm/ci/xfails/panfrost*
-F:	drivers/gpu/drm/panfrost/
-F:	include/uapi/drm/panfrost_drm.h
-
 ARM MALI-C55 ISP DRIVER
 M:	Daniel Scally <dan.scally@ideasonboard.com>
 M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
@@ -2368,6 +2369,27 @@ F:	Documentation/userspace-api/media/v4l
 F:	drivers/media/platform/arm/mali-c55/
 F:	include/uapi/linux/media/arm/mali-c55-config.h
 
+ARM MALI-DP DRM DRIVER
+M:	Liviu Dudau <liviu.dudau@arm.com>
+S:	Supported
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/devicetree/bindings/display/arm,malidp.yaml
+F:	Documentation/gpu/afbc.rst
+F:	drivers/gpu/drm/arm/
+
+ARM MALI PANFROST DRM DRIVER
+M:	Boris Brezillon <boris.brezillon@collabora.com>
+M:	Rob Herring <robh@kernel.org>
+M:	Steven Price <steven.price@arm.com>
+M:	Adrián Larumbe <adrian.larumbe@collabora.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/gpu/panfrost.rst
+F:	drivers/gpu/drm/ci/xfails/panfrost*
+F:	drivers/gpu/drm/panfrost/
+F:	include/uapi/drm/panfrost_drm.h
+
 ARM MALI PANTHOR DRM DRIVER
 M:	Boris Brezillon <boris.brezillon@collabora.com>
 M:	Steven Price <steven.price@arm.com>
@@ -2394,14 +2416,6 @@ F:	Documentation/devicetree/bindings/gpu
 F:	drivers/gpu/drm/tyr/
 F:	include/uapi/drm/panthor_drm.h
 
-ARM MALI-DP DRM DRIVER
-M:	Liviu Dudau <liviu.dudau@arm.com>
-S:	Supported
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/devicetree/bindings/display/arm,malidp.yaml
-F:	Documentation/gpu/afbc.rst
-F:	drivers/gpu/drm/arm/
-
 ARM MFM AND FLOPPY DRIVERS
 M:	Ian Molton <spyro@f2s.com>
 S:	Maintained
@@ -2762,6 +2776,15 @@ F:	drivers/crypto/axis
 F:	drivers/mmc/host/usdhi6rol0.c
 F:	drivers/pinctrl/pinctrl-artpec*
 
+ARM/ASPEED CLOCK SUPPORT
+M:	Ryan Chen <ryan_chen@aspeedtech.com>
+R:	Joel Stanley <joel@jms.id.au>
+L:	linux-clk@vger.kernel.org
+L:	linux-aspeed@lists.ozlabs.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/mfd/aspeed,ast2x00-scu.yaml
+F:	drivers/clk/aspeed/
+
 ARM/ASPEED I2C DRIVER
 M:	Ryan Chen <ryan_chen@aspeedtech.com>
 R:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
@@ -3134,14 +3157,6 @@ F:	drivers/usb/host/ohci-nxp.c
 F:	drivers/watchdog/pnx4008_wdt.c
 N:	lpc32xx
 
-LPC32XX DMAMUX SUPPORT
-M:	J.M.B. Downing <jonathan.downing@nautel.com>
-M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
-R:	Vladimir Zapolskiy <vz@mleia.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	Documentation/devicetree/bindings/dma/nxp,lpc3220-dmamux.yaml
-
 ARM/Marvell Dove/MV78xx0/Orion SOC support
 M:	Andrew Lunn <andrew@lunn.ch>
 M:	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
@@ -4054,20 +4069,6 @@ S:	Supported
 W:	http://www.akm.com/
 F:	drivers/iio/magnetometer/ak8974.c
 
-AOSONG AGS02MA TVOC SENSOR DRIVER
-M:	Anshul Dalal <anshulusr@gmail.com>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/chemical/aosong,ags02ma.yaml
-F:	drivers/iio/chemical/ags02ma.c
-
-AOSONG ADP810 DIFFERENTIAL PRESSURE SENSOR DRIVER
-M:	Akhilesh Patil <akhilesh@ee.iitb.ac.in>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/pressure/aosong,adp810.yaml
-F:	drivers/iio/pressure/adp810.c
-
 ASC7621 HARDWARE MONITOR DRIVER
 M:	George Joseph <george.joseph@fairview5.com>
 L:	linux-hwmon@vger.kernel.org
@@ -4089,15 +4090,6 @@ L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/ax88796b_rust.rs
 
-ARM/ASPEED CLOCK SUPPORT
-M:	Ryan Chen <ryan_chen@aspeedtech.com>
-R:	Joel Stanley <joel@jms.id.au>
-L:	linux-clk@vger.kernel.org
-L:	linux-aspeed@lists.ozlabs.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/mfd/aspeed,ast2x00-scu.yaml
-F:	drivers/clk/aspeed/
-
 ASPEED CRYPTO DRIVER
 M:	Neal Liu <neal_liu@aspeedtech.com>
 L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
@@ -4105,6 +4097,14 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/aspeed,*
 F:	drivers/crypto/aspeed/
 
+ASPEED PCIE CONTROLLER DRIVER
+M:	Jacky Chou <jacky_chou@aspeedtech.com>
+L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/pci/aspeed,ast2600-pcie.yaml
+F:	drivers/pci/controller/pcie-aspeed.c
+
 ASPEED PECI CONTROLLER
 M:	Iwona Winiarska <iwona.winiarska@intel.com>
 L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
@@ -4164,14 +4164,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/media/aspeed,video-engine.yaml
 F:	drivers/media/platform/aspeed/
 
-ASPEED PCIE CONTROLLER DRIVER
-M:	Jacky Chou <jacky_chou@aspeedtech.com>
-L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
-L:	linux-pci@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/pci/aspeed,ast2600-pcie.yaml
-F:	drivers/pci/controller/pcie-aspeed.c
-
 ASUS EC HARDWARE MONITOR DRIVER
 M:	Eugene Shalygin <eugene.shalygin@gmail.com>
 L:	linux-hwmon@vger.kernel.org
@@ -4188,6 +4180,12 @@ W:	https://asus-linux.org/
 F:	drivers/platform/x86/asus*.c
 F:	drivers/platform/x86/eeepc*.c
 
+ASUS ROG RYUJIN AIO HARDWARE MONITOR DRIVER
+M:	Aleksa Savic <savicaleksa83@gmail.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	drivers/hwmon/asus_rog_ryujin.c
+
 ASUS TF103C DOCK DRIVER
 M:	Hans de Goede <hansg@kernel.org>
 L:	platform-driver-x86@vger.kernel.org
@@ -4195,12 +4193,6 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git
 F:	drivers/platform/x86/asus-tf103c-dock.c
 
-ASUS ROG RYUJIN AIO HARDWARE MONITOR DRIVER
-M:	Aleksa Savic <savicaleksa83@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	drivers/hwmon/asus_rog_ryujin.c
-
 ASUS WIRELESS RADIO CONTROL DRIVER
 M:	João Paulo Rechi Vita <jprvita@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -4513,36 +4505,6 @@ S:	Orphan
 F:	Documentation/devicetree/bindings/sound/axentia,*
 F:	sound/soc/atmel/tse850-pcm5142.c
 
-AXIADO SARADC DRIVER
-M:	Petar Stepanovic <pstepanovic@axiado.com>
-M:	Akhila Kavi <akavi@axiado.com>
-M:	Prasad Bolisetty <pbolisetty@axiado.com>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/adc/axiado,ax3000-saradc.yaml
-F:	drivers/iio/adc/axiado_saradc.c
-
-AXIADO SGPIO DRIVER
-M:	Petar Stepanovic <pstepanovic@axiado.com>
-M:	SriNavmani A <srinavmani@axiado.com>
-M:	Prasad Bolisetty <pbolisetty@axiado.com>
-L:	linux-gpio@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/gpio/axiado,ax3005-sgpio.yaml
-F:	drivers/gpio/gpio-axiado-sgpio.c
-
-AXIS ARTPEC ARM64 SoC SUPPORT
-M:	Jesper Nilsson <jesper.nilsson@axis.com>
-M:	Lars Persson <lars.persson@axis.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	linux-samsung-soc@vger.kernel.org
-L:	linux-arm-kernel@axis.com
-S:	Maintained
-F:	Documentation/devicetree/bindings/clock/axis,artpec*-clock.yaml
-F:	arch/arm64/boot/dts/exynos/axis/
-F:	drivers/clk/samsung/clk-artpec*.c
-F:	include/dt-bindings/clock/axis,artpec*-clk.h
-
 AXI-FAN-CONTROL HARDWARE MONITOR DRIVER
 M:	Nuno Sá <nuno.sa@analog.com>
 L:	linux-hwmon@vger.kernel.org
@@ -4551,6 +4513,26 @@ W:	https://ez.analog.com/linux-software-
 F:	Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
 F:	drivers/hwmon/axi-fan-control.c
 
+AXI PWM GENERATOR
+M:	Michael Hennerich <michael.hennerich@analog.com>
+M:	Nuno Sá <nuno.sa@analog.com>
+R:	Trevor Gamblin <tgamblin@baylibre.com>
+L:	linux-pwm@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
+F:	drivers/pwm/pwm-axi-pwmgen.c
+
+AXI SPI ENGINE
+M:	Michael Hennerich <michael.hennerich@analog.com>
+M:	Nuno Sá <nuno.sa@analog.com>
+R:	David Lechner <dlechner@baylibre.com>
+L:	linux-spi@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/spi/adi,axi-spi-engine.yaml
+F:	drivers/spi/spi-axi-spi-engine.c
+
 AXIADO EMMC PHY DRIVER
 M:	SriNavmani A <srinavmani@axiado.com>
 M:	Tzu-Hao Wei <twei@axiado.com>
@@ -4569,26 +4551,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/mailbox/axiado,ax3005-mailbox.yaml
 F:	drivers/mailbox/axiado-mailbox.c
 
-AXI SPI ENGINE
-M:	Michael Hennerich <michael.hennerich@analog.com>
-M:	Nuno Sá <nuno.sa@analog.com>
-R:	David Lechner <dlechner@baylibre.com>
-L:	linux-spi@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/spi/adi,axi-spi-engine.yaml
-F:	drivers/spi/spi-axi-spi-engine.c
-
-AXI PWM GENERATOR
-M:	Michael Hennerich <michael.hennerich@analog.com>
-M:	Nuno Sá <nuno.sa@analog.com>
-R:	Trevor Gamblin <tgamblin@baylibre.com>
-L:	linux-pwm@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
-F:	drivers/pwm/pwm-axi-pwmgen.c
-
 AXIADO PWM FAN CONTROLLER DRIVER
 M:	Petar Stepanovic <pstepanovic@axiado.com>
 M:	Akhila Kavi <akavi@axiado.com>
@@ -4599,6 +4561,24 @@ F:	Documentation/devicetree/bindings/hwm
 F:	Documentation/hwmon/axiado-pwm-fan.rst
 F:	drivers/hwmon/axiado-pwm-fan.c
 
+AXIADO SARADC DRIVER
+M:	Petar Stepanovic <pstepanovic@axiado.com>
+M:	Akhila Kavi <akavi@axiado.com>
+M:	Prasad Bolisetty <pbolisetty@axiado.com>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/iio/adc/axiado,ax3000-saradc.yaml
+F:	drivers/iio/adc/axiado_saradc.c
+
+AXIADO SGPIO DRIVER
+M:	Petar Stepanovic <pstepanovic@axiado.com>
+M:	SriNavmani A <srinavmani@axiado.com>
+M:	Prasad Bolisetty <pbolisetty@axiado.com>
+L:	linux-gpio@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/gpio/axiado,ax3005-sgpio.yaml
+F:	drivers/gpio/gpio-axiado-sgpio.c
+
 AXIADO SPI DB DRIVER
 M:	Vladimir Moravcevic <vmoravcevic@axiado.com>
 M:	Tzu-Hao Wei <twei@axiado.com>
@@ -4620,6 +4600,18 @@ F:	Documentation/devicetree/bindings/hwm
 F:	Documentation/hwmon/axiado-tsadc.rst
 F:	drivers/hwmon/axiado-tsadc.c
 
+AXIS ARTPEC ARM64 SoC SUPPORT
+M:	Jesper Nilsson <jesper.nilsson@axis.com>
+M:	Lars Persson <lars.persson@axis.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org
+L:	linux-arm-kernel@axis.com
+S:	Maintained
+F:	Documentation/devicetree/bindings/clock/axis,artpec*-clock.yaml
+F:	arch/arm64/boot/dts/exynos/axis/
+F:	drivers/clk/samsung/clk-artpec*.c
+F:	include/dt-bindings/clock/axis,artpec*-clk.h
+
 AYANEO PLATFORM EC DRIVER
 M:	Antheas Kapenekakis <lkml@antheas.dev>
 L:	platform-driver-x86@vger.kernel.org
@@ -4774,12 +4766,6 @@ F:	tools/include/vdso/bits.h
 F:	tools/lib/bitmap.c
 F:	tools/lib/find_bit.c
 
-BITMAP API BINDINGS [RUST]
-M:	Yury Norov <yury.norov@gmail.com>
-S:	Maintained
-F:	rust/helpers/bitmap.c
-F:	rust/helpers/cpumask.c
-
 BITMAP API [RUST]
 M:	Alice Ryhl <aliceryhl@google.com>
 M:	Burak Emir <burak.emir@gmail.com>
@@ -4789,6 +4775,12 @@ F:	lib/find_bit_benchmark_rust.rs
 F:	rust/kernel/bitmap.rs
 F:	rust/kernel/id_pool.rs
 
+BITMAP API BINDINGS [RUST]
+M:	Yury Norov <yury.norov@gmail.com>
+S:	Maintained
+F:	rust/helpers/bitmap.c
+F:	rust/helpers/cpumask.c
+
 BITOPS API
 M:	Yury Norov <yury.norov@gmail.com>
 R:	Rasmus Villemoes <linux@rasmusvillemoes.dk>
@@ -4926,103 +4918,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/imu/bosch,bmi323.yaml
 F:	drivers/iio/imu/bmi323/
 
-BPF JIT for ARC
-M:	Shahab Vahedi <list+bpf@vahedi.org>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/arc/net/
-
-BPF JIT for ARM
-M:	Russell King <linux@armlinux.org.uk>
-M:	Puranjay Mohan <puranjay@kernel.org>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/arm/net/
-
-BPF JIT for ARM64
-M:	Daniel Borkmann <daniel@iogearbox.net>
-M:	Alexei Starovoitov <ast@kernel.org>
-M:	Puranjay Mohan <puranjay@kernel.org>
-R:	Xu Kuohai <xukuohai@huaweicloud.com>
-L:	bpf@vger.kernel.org
-S:	Supported
-F:	arch/arm64/net/
-
-BPF JIT for LOONGARCH
-M:	Tiezhu Yang <yangtiezhu@loongson.cn>
-R:	Hengqi Chen <hengqi.chen@gmail.com>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/loongarch/net/
-
-BPF JIT for MIPS (32-BIT AND 64-BIT)
-M:	Johan Almbladh <johan.almbladh@anyfinetworks.com>
-M:	Paul Burton <paulburton@kernel.org>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/mips/net/
-
-BPF JIT for NFP NICs
-M:	Jakub Kicinski <kuba@kernel.org>
-L:	bpf@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/net/ethernet/netronome/nfp/bpf/
-
-BPF JIT for POWERPC (32-BIT AND 64-BIT)
-M:	Hari Bathini <hbathini@linux.ibm.com>
-M:	Christophe Leroy (CS GROUP) <chleroy@kernel.org>
-R:	Naveen N Rao <naveen@kernel.org>
-L:	bpf@vger.kernel.org
-S:	Supported
-F:	arch/powerpc/net/
-
-BPF JIT for RISC-V (32-bit)
-M:	Luke Nelson <luke.r.nels@gmail.com>
-M:	Xi Wang <xi.wang@gmail.com>
-M:	Pu Lehui <pulehui@huawei.com>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/riscv/net/
-X:	arch/riscv/net/bpf_jit_comp64.c
-
-BPF JIT for RISC-V (64-bit)
-M:	Björn Töpel <bjorn@kernel.org>
-M:	Pu Lehui <pulehui@huawei.com>
-R:	Puranjay Mohan <puranjay@kernel.org>
-L:	bpf@vger.kernel.org
-S:	Maintained
-F:	arch/riscv/net/
-X:	arch/riscv/net/bpf_jit_comp32.c
-
-BPF JIT for S390
-M:	Ilya Leoshkevich <iii@linux.ibm.com>
-M:	Heiko Carstens <hca@linux.ibm.com>
-M:	Vasily Gorbik <gor@linux.ibm.com>
-L:	bpf@vger.kernel.org
-S:	Supported
-F:	arch/s390/net/
-X:	arch/s390/net/pnet.c
-
-BPF JIT for SPARC (32-BIT AND 64-BIT)
-M:	David S. Miller <davem@davemloft.net>
-L:	bpf@vger.kernel.org
-S:	Odd Fixes
-F:	arch/sparc/net/
-
-BPF JIT for X86 32-BIT
-M:	Wang YanQing <udknight@gmail.com>
-L:	bpf@vger.kernel.org
-S:	Odd Fixes
-F:	arch/x86/net/bpf_jit_comp32.c
-
-BPF JIT for X86 64-BIT
-M:	Alexei Starovoitov <ast@kernel.org>
-M:	Daniel Borkmann <daniel@iogearbox.net>
-L:	bpf@vger.kernel.org
-S:	Supported
-F:	arch/x86/net/
-X:	arch/x86/net/bpf_jit_comp32.c
-
 BPF [CORE]
 M:	Alexei Starovoitov <ast@kernel.org>
 M:	Daniel Borkmann <daniel@iogearbox.net>
@@ -5212,6 +5107,110 @@ F:	kernel/bpf/stackmap.c
 F:	kernel/trace/bpf_trace.c
 F:	lib/buildid.c
 
+BPF JIT for ARC
+M:	Shahab Vahedi <list+bpf@vahedi.org>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/arc/net/
+
+BPF JIT for ARM
+M:	Russell King <linux@armlinux.org.uk>
+M:	Puranjay Mohan <puranjay@kernel.org>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/arm/net/
+
+BPF JIT for ARM64
+M:	Daniel Borkmann <daniel@iogearbox.net>
+M:	Alexei Starovoitov <ast@kernel.org>
+M:	Puranjay Mohan <puranjay@kernel.org>
+R:	Xu Kuohai <xukuohai@huaweicloud.com>
+L:	bpf@vger.kernel.org
+S:	Supported
+F:	arch/arm64/net/
+
+BPF JIT for LOONGARCH
+M:	Tiezhu Yang <yangtiezhu@loongson.cn>
+R:	Hengqi Chen <hengqi.chen@gmail.com>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/loongarch/net/
+
+BPF JIT for MIPS (32-BIT AND 64-BIT)
+M:	Johan Almbladh <johan.almbladh@anyfinetworks.com>
+M:	Paul Burton <paulburton@kernel.org>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/mips/net/
+
+BPF JIT for NFP NICs
+M:	Jakub Kicinski <kuba@kernel.org>
+L:	bpf@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/net/ethernet/netronome/nfp/bpf/
+
+BPF JIT for POWERPC (32-BIT AND 64-BIT)
+M:	Hari Bathini <hbathini@linux.ibm.com>
+M:	Christophe Leroy (CS GROUP) <chleroy@kernel.org>
+R:	Naveen N Rao <naveen@kernel.org>
+L:	bpf@vger.kernel.org
+S:	Supported
+F:	arch/powerpc/net/
+
+BPF JIT for RISC-V (32-bit)
+M:	Luke Nelson <luke.r.nels@gmail.com>
+M:	Xi Wang <xi.wang@gmail.com>
+M:	Pu Lehui <pulehui@huawei.com>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/riscv/net/
+X:	arch/riscv/net/bpf_jit_comp64.c
+
+BPF JIT for RISC-V (64-bit)
+M:	Björn Töpel <bjorn@kernel.org>
+M:	Pu Lehui <pulehui@huawei.com>
+R:	Puranjay Mohan <puranjay@kernel.org>
+L:	bpf@vger.kernel.org
+S:	Maintained
+F:	arch/riscv/net/
+X:	arch/riscv/net/bpf_jit_comp32.c
+
+BPF JIT for S390
+M:	Ilya Leoshkevich <iii@linux.ibm.com>
+M:	Heiko Carstens <hca@linux.ibm.com>
+M:	Vasily Gorbik <gor@linux.ibm.com>
+L:	bpf@vger.kernel.org
+S:	Supported
+F:	arch/s390/net/
+X:	arch/s390/net/pnet.c
+
+BPF JIT for SPARC (32-BIT AND 64-BIT)
+M:	David S. Miller <davem@davemloft.net>
+L:	bpf@vger.kernel.org
+S:	Odd Fixes
+F:	arch/sparc/net/
+
+BPF JIT for X86 32-BIT
+M:	Wang YanQing <udknight@gmail.com>
+L:	bpf@vger.kernel.org
+S:	Odd Fixes
+F:	arch/x86/net/bpf_jit_comp32.c
+
+BPF JIT for X86 64-BIT
+M:	Alexei Starovoitov <ast@kernel.org>
+M:	Daniel Borkmann <daniel@iogearbox.net>
+L:	bpf@vger.kernel.org
+S:	Supported
+F:	arch/x86/net/
+X:	arch/x86/net/bpf_jit_comp32.c
+
+BROADCOM 800 GIGABIT ROCE DRIVER
+M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+W:	http://www.broadcom.com
+F:	drivers/infiniband/hw/bng_re/
+
 BROADCOM APDS9160 AMBIENT LIGHT SENSOR AND PROXIMITY DRIVER
 M:	Mikael Gonella-Bolduc <m.gonella.bolduc@gmail.com>
 L:	linux-iio@vger.kernel.org
@@ -5352,6 +5351,13 @@ S:	Maintained
 F:	arch/arm/boot/dts/broadcom/bcm47189*
 F:	arch/arm/boot/dts/broadcom/bcm53573*
 
+BROADCOM BCM6348/BCM6358 SPI controller DRIVER
+M:	Jonas Gorski <jonas.gorski@gmail.com>
+L:	linux-spi@vger.kernel.org
+S:	Odd Fixes
+F:	Documentation/devicetree/bindings/spi/brcm,bcm63xx-spi.yaml
+F:	drivers/spi/spi-bcm63xx.c
+
 BROADCOM BCM63XX/BCM33XX UDC DRIVER
 M:	Kevin Cernekee <cernekee@gmail.com>
 L:	linux-usb@vger.kernel.org
@@ -5436,6 +5442,13 @@ F:	drivers/pmdomain/bcm/bcm63xx-power.c
 F:	include/linux/bcm963xx_nvram.h
 F:	include/linux/bcm963xx_tag.h
 
+BROADCOM BNG_EN 800 GIGABIT ETHERNET DRIVER
+M:	Vikas Gupta <vikas.gupta@broadcom.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/broadcom/bnge/
+F:	include/linux/bnge/hsi.h
+
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
 M:	Rasesh Mody <rmody@marvell.com>
 M:	GR-Linux-NIC-Dev@marvell.com
@@ -5476,13 +5489,6 @@ F:	drivers/firmware/broadcom/tee_bnxt_fw
 F:	drivers/net/ethernet/broadcom/bnxt/
 F:	include/linux/firmware/broadcom/tee_bnxt_fw.h
 
-BROADCOM BNG_EN 800 GIGABIT ETHERNET DRIVER
-M:	Vikas Gupta <vikas.gupta@broadcom.com>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/ethernet/broadcom/bnge/
-F:	include/linux/bnge/hsi.h
-
 BROADCOM BRCM80211 IEEE802.11 WIRELESS DRIVERS
 M:	Arend van Spriel <arend.vanspriel@broadcom.com>
 L:	linux-wireless@vger.kernel.org
@@ -5552,13 +5558,6 @@ F:	Documentation/devicetree/bindings/spi
 F:	drivers/spi/spi-bcm63xx-hsspi.c
 F:	drivers/spi/spi-bcmbca-hsspi.c
 
-BROADCOM BCM6348/BCM6358 SPI controller DRIVER
-M:	Jonas Gorski <jonas.gorski@gmail.com>
-L:	linux-spi@vger.kernel.org
-S:	Odd Fixes
-F:	Documentation/devicetree/bindings/spi/brcm,bcm63xx-spi.yaml
-F:	drivers/spi/spi-bcm63xx.c
-
 BROADCOM ETHERNET PHY DRIVERS
 M:	Florian Fainelli <florian.fainelli@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
@@ -5648,13 +5647,6 @@ W:	http://www.broadcom.com
 F:	drivers/infiniband/hw/bnxt_re/
 F:	include/uapi/rdma/bnxt_re-abi.h
 
-BROADCOM 800 GIGABIT ROCE DRIVER
-M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
-L:	linux-rdma@vger.kernel.org
-S:	Supported
-W:	http://www.broadcom.com
-F:	drivers/infiniband/hw/bng_re/
-
 BROADCOM NVRAM DRIVER
 M:	Rafał Miłecki <zajec5@gmail.com>
 L:	linux-mips@vger.kernel.org
@@ -5940,6 +5932,16 @@ L:	cake@lists.bufferbloat.net (moderated
 S:	Maintained
 F:	net/sched/sch_cake.c
 
+CAN-J1939 NETWORK LAYER
+M:	Robin van der Gracht <robin@protonic.nl>
+M:	Oleksij Rempel <o.rempel@pengutronix.de>
+R:	kernel@pengutronix.de
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/j1939.rst
+F:	include/uapi/linux/can/j1939.h
+F:	net/can/j1939/
+
 CAN NETWORK DRIVERS
 M:	Marc Kleine-Budde <mkl@pengutronix.de>
 M:	Vincent Mailhol <mailhol@kernel.org>
@@ -5985,16 +5987,6 @@ F:	net/can/
 F:	net/sched/em_canid.c
 F:	tools/testing/selftests/net/can/
 
-CAN-J1939 NETWORK LAYER
-M:	Robin van der Gracht <robin@protonic.nl>
-M:	Oleksij Rempel <o.rempel@pengutronix.de>
-R:	kernel@pengutronix.de
-L:	linux-can@vger.kernel.org
-S:	Maintained
-F:	Documentation/networking/j1939.rst
-F:	include/uapi/linux/can/j1939.h
-F:	net/can/j1939/
-
 CANAAN/KENDRYTE K210 SOC FPIOA DRIVER
 M:	Damien Le Moal <dlemoal@kernel.org>
 L:	linux-riscv@lists.infradead.org
@@ -6265,6 +6257,11 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux.git
 F:	drivers/platform/chrome/
 
+CHROMEOS EC CHARGE CONTROL
+M:	Thomas Weißschuh <linux@weissschuh.net>
+S:	Maintained
+F:	drivers/power/supply/cros_charge-control.c
+
 CHROMEOS EC CODEC DRIVER
 M:	Cheng-Yi Chiang <cychiang@chromium.org>
 M:	Tzung-Bi Shih <tzungbi@kernel.org>
@@ -6274,11 +6271,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
 F:	sound/soc/codecs/cros_ec_codec.*
 
-CHROMEOS EC CHARGE CONTROL
-M:	Thomas Weißschuh <linux@weissschuh.net>
-S:	Maintained
-F:	drivers/power/supply/cros_charge-control.c
-
 CHROMEOS EC HARDWARE MONITORING
 M:	Thomas Weißschuh <linux@weissschuh.net>
 L:	chrome-platform@lists.linux.dev
@@ -6330,18 +6322,18 @@ F:	drivers/platform/chrome/cros_typec_al
 F:	drivers/platform/chrome/cros_typec_switch.c
 F:	drivers/platform/chrome/cros_typec_vdm.*
 
-CHROMEOS HPS DRIVER
-M:	Dan Callaghan <dcallagh@chromium.org>
-R:	Sami Kyöstilä <skyostil@chromium.org>
-S:	Maintained
-F:	drivers/platform/chrome/cros_hps_i2c.c
-
 CHROMEOS EC WATCHDOG
 M:	Lukasz Majczak <lma@chromium.org>
 L:	chrome-platform@lists.linux.dev
 S:	Maintained
 F:	drivers/watchdog/cros_ec_wdt.c
 
+CHROMEOS HPS DRIVER
+M:	Dan Callaghan <dcallagh@chromium.org>
+R:	Sami Kyöstilä <skyostil@chromium.org>
+S:	Maintained
+F:	drivers/platform/chrome/cros_hps_i2c.c
+
 CHROMEOS UCSI DRIVER
 M:	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
 M:	Łukasz Bartosik <ukaszb@chromium.org>
@@ -6379,18 +6371,6 @@ F:	sound/hda/codecs/side-codecs/cs*
 F:	sound/hda/codecs/side-codecs/hda_component*
 F:	sound/soc/codecs/cs*
 
-CIRRUS LOGIC HAPTIC DRIVERS
-M:	James Ogletree <jogletre@opensource.cirrus.com>
-M:	Fred Treven <fred.treven@cirrus.com>
-M:	Ben Bright <ben.bright@cirrus.com>
-L:	patches@opensource.cirrus.com
-S:	Supported
-F:	Documentation/devicetree/bindings/input/cirrus,cs40l50.yaml
-F:	drivers/input/misc/cs40l*
-F:	drivers/mfd/cs40l*
-F:	include/linux/mfd/cs40l*
-F:	sound/soc/codecs/cs40l*
-
 CIRRUS LOGIC DSP FIRMWARE DRIVER
 M:	Simon Trimmer <simont@opensource.cirrus.com>
 M:	Charles Keepax <ckeepax@opensource.cirrus.com>
@@ -6408,6 +6388,18 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/cirrus/ep93xx_eth.c
 
+CIRRUS LOGIC HAPTIC DRIVERS
+M:	James Ogletree <jogletre@opensource.cirrus.com>
+M:	Fred Treven <fred.treven@cirrus.com>
+M:	Ben Bright <ben.bright@cirrus.com>
+L:	patches@opensource.cirrus.com
+S:	Supported
+F:	Documentation/devicetree/bindings/input/cirrus,cs40l50.yaml
+F:	drivers/input/misc/cs40l*
+F:	drivers/mfd/cs40l*
+F:	include/linux/mfd/cs40l*
+F:	sound/soc/codecs/cs40l*
+
 CIRRUS LOGIC LOCHNAGAR DRIVER
 M:	Charles Keepax <ckeepax@opensource.cirrus.com>
 M:	Richard Fitzgerald <rf@opensource.cirrus.com>
@@ -6762,19 +6754,6 @@ S:	Maintained
 F:	include/linux/context_tracking*
 F:	kernel/context_tracking.c
 
-CONTROL GROUP (CGROUP)
-M:	Tejun Heo <tj@kernel.org>
-M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Michal Koutný <mkoutny@suse.com>
-L:	cgroups@vger.kernel.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-F:	Documentation/admin-guide/cgroup-v1/
-F:	Documentation/admin-guide/cgroup-v2.rst
-F:	include/linux/cgroup*
-F:	kernel/cgroup/
-F:	tools/testing/selftests/cgroup/
-
 CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
 M:	Tejun Heo <tj@kernel.org>
 M:	Josef Bacik <josef@toxicpanda.com>
@@ -6816,28 +6795,30 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	include/linux/cgroup_dmem.h
 F:	kernel/cgroup/dmem.c
 
-MEMORY MANAGEMENT - MEMORY RESOURCE CONTROLLER (MEMCG)
+CONTROL GROUP (CGROUP)
+M:	Tejun Heo <tj@kernel.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Michal Hocko <mhocko@kernel.org>
-M:	Roman Gushchin <roman.gushchin@linux.dev>
-M:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Muchun Song <muchun.song@linux.dev>
+M:	Michal Koutný <mkoutny@suse.com>
 L:	cgroups@vger.kernel.org
-L:	linux-mm@kvack.org
 S:	Maintained
-F:	Documentation/admin-guide/cgroup-v1/memory.rst
-F:	include/linux/memcontrol.h
-F:	include/linux/page_counter.h
-F:	include/trace/events/memcg.h
-F:	mm/memcontrol-v1.c
-F:	mm/memcontrol-v1.h
-F:	mm/memcontrol.c
-F:	mm/page_counter.c
-F:	samples/cgroup/*
-F:	tools/testing/selftests/cgroup/memcg_protection.m
-F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
-F:	tools/testing/selftests/cgroup/test_kmem.c
-F:	tools/testing/selftests/cgroup/test_memcontrol.c
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
+F:	Documentation/admin-guide/cgroup-v1/
+F:	Documentation/admin-guide/cgroup-v2.rst
+F:	include/linux/cgroup*
+F:	kernel/cgroup/
+F:	tools/testing/selftests/cgroup/
+
+CORE DRIVER FOR NVIDIA GPUS [RUST]
+M:	Danilo Krummrich <dakr@kernel.org>
+M:	Alexandre Courbot <acourbot@nvidia.com>
+L:	nova-gpu@lists.linux.dev
+S:	Supported
+W:	https://rust-for-linux.com/nova-gpu-driver
+B:	https://gitlab.freedesktop.org/drm/nova/-/issues
+C:	irc://irc.oftc.net/nouveau
+T:	git https://gitlab.freedesktop.org/drm/rust/kernel.git drm-rust-next
+F:	Documentation/gpu/nova/
+F:	drivers/gpu/nova-core/
 
 COREBOOT CFR FIRMWARE ATTRIBUTES DRIVER
 M:	Sean Rhodes <sean@starlabs.systems>
@@ -7088,13 +7069,6 @@ F:	kernel/cred.c
 F:	rust/kernel/cred.rs
 F:	Documentation/security/credentials.rst
 
-INTEL CRPS COMMON REDUNDANT PSU DRIVER
-M:	Ninad Palsule <ninad@linux.ibm.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/crps.rst
-F:	drivers/hwmon/pmbus/crps.c
-
 CRYPTO API
 M:	Herbert Xu <herbert@gondor.apana.org.au>
 M:	"David S. Miller" <davem@davemloft.net>
@@ -7322,25 +7296,6 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-MEMORY MANAGEMENT - DAMON
-M:	SJ Park <sj@kernel.org>
-L:	damon@lists.linux.dev
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	https://damonitor.github.io
-P:	Documentation/mm/damon/maintainer-profile.rst
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
-F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
-F:	Documentation/admin-guide/mm/damon/
-F:	Documentation/mm/damon/
-F:	include/linux/damon.h
-F:	include/trace/events/damon.h
-F:	mm/damon/
-F:	samples/damon/
-F:	tools/testing/selftests/damon/
-
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 L:	netdev@vger.kernel.org
 S:	Orphan
@@ -7402,6 +7357,24 @@ T:	git git://linuxtv.org/media.git
 F:	Documentation/devicetree/bindings/media/allwinner,sun8i-h3-deinterlace.yaml
 F:	drivers/media/platform/sunxi/sun8i-di/
 
+DELAY, SLEEP, TIMEKEEPING, TIMERS [RUST]
+M:	Andreas Hindborg <a.hindborg@kernel.org>
+R:	Boqun Feng <boqun@kernel.org>
+R:	FUJITA Tomonori <fujita.tomonori@gmail.com>
+R:	Frederic Weisbecker <frederic@kernel.org>
+R:	Lyude Paul <lyude@redhat.com>
+R:	Thomas Gleixner <tglx@kernel.org>
+R:	Anna-Maria Behnsen <anna-maria@linutronix.de>
+R:	John Stultz <jstultz@google.com>
+R:	Stephen Boyd <sboyd@kernel.org>
+L:	rust-for-linux@vger.kernel.org
+S:	Supported
+W:	https://rust-for-linux.com
+B:	https://github.com/Rust-for-Linux/linux/issues
+T:	git https://github.com/Rust-for-Linux/linux.git timekeeping-next
+F:	rust/kernel/time.rs
+F:	rust/kernel/time/
+
 DELL LAPTOP DRIVER
 M:	Matthew Garrett <mjg59@srcf.ucam.org>
 M:	Pali Rohár <pali@kernel.org>
@@ -7637,12 +7610,6 @@ F:	rust/kernel/irq.rs
 F:	rust/kernel/irq/
 F:	rust/macros/io/
 
-DEVICE RESOURCE MANAGEMENT HELPERS
-M:	Hans de Goede <hansg@kernel.org>
-R:	Matti Vaittinen <mazziesaccount@gmail.com>
-S:	Maintained
-F:	include/linux/devm-helpers.h
-
 DEVICE-MAPPER  (LVM)
 M:	Alasdair Kergon <agk@redhat.com>
 M:	Mike Snitzer <snitzer@kernel.org>
@@ -7661,6 +7628,14 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
+DEVICE-MAPPER PCACHE TARGET
+M:	Dongsheng Yang <dongsheng.yang@linux.dev>
+M:	Zheng Gu <cengku@gmail.com>
+L:	dm-devel@lists.linux.dev
+S:	Maintained
+F:	Documentation/admin-guide/device-mapper/dm-pcache.rst
+F:	drivers/md/dm-pcache/
+
 DEVICE-MAPPER VDO TARGET
 M:	Matthew Sakai <msakai@redhat.com>
 L:	dm-devel@lists.linux.dev
@@ -7668,13 +7643,11 @@ S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
 F:	drivers/md/dm-vdo/
 
-DEVICE-MAPPER PCACHE TARGET
-M:	Dongsheng Yang <dongsheng.yang@linux.dev>
-M:	Zheng Gu <cengku@gmail.com>
-L:	dm-devel@lists.linux.dev
+DEVICE RESOURCE MANAGEMENT HELPERS
+M:	Hans de Goede <hansg@kernel.org>
+R:	Matti Vaittinen <mazziesaccount@gmail.com>
 S:	Maintained
-F:	Documentation/admin-guide/device-mapper/dm-pcache.rst
-F:	drivers/md/dm-pcache/
+F:	include/linux/devm-helpers.h
 
 DEVLINK
 M:	Jiri Pirko <jiri@resnulli.us>
@@ -7820,6 +7793,24 @@ W:	https://pagure.io/dlm
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git
 F:	fs/dlm/
 
+DMA-BUF HEAPS FRAMEWORK
+M:	Sumit Semwal <sumit.semwal@linaro.org>
+R:	Benjamin Gaignard <benjamin.gaignard@collabora.com>
+R:	Brian Starkey <Brian.Starkey@arm.com>
+R:	John Stultz <jstultz@google.com>
+R:	T.J. Mercier <tjmercier@google.com>
+L:	linux-media@vger.kernel.org
+L:	dri-devel@lists.freedesktop.org
+L:	linaro-mm-sig@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/userspace-api/dma-buf-heaps.rst
+F:	drivers/dma-buf/dma-heap.c
+F:	drivers/dma-buf/heaps/*
+F:	include/linux/dma-heap.h
+F:	include/uapi/linux/dma-heap.h
+F:	tools/testing/selftests/dmabuf-heaps/
+
 DMA BUFFER SHARING FRAMEWORK
 M:	Sumit Semwal <sumit.semwal@linaro.org>
 M:	Christian König <christian.koenig@amd.com>
@@ -7856,6 +7847,22 @@ F:	include/linux/dma/
 F:	include/linux/dmaengine.h
 F:	include/linux/of_dma.h
 
+DMA MAPPING & SCATTERLIST API [RUST]
+M:	Danilo Krummrich <dakr@kernel.org>
+R:	Abdiel Janulgue <abdiel.janulgue@gmail.com>
+R:	Daniel Almeida <daniel.almeida@collabora.com>
+R:	Robin Murphy <robin.murphy@arm.com>
+R:	Andreas Hindborg <a.hindborg@kernel.org>
+L:	driver-core@lists.linux.dev
+S:	Supported
+W:	https://rust-for-linux.com
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
+F:	rust/helpers/dma.c
+F:	rust/helpers/scatterlist.c
+F:	rust/kernel/dma.rs
+F:	rust/kernel/scatterlist.rs
+F:	samples/rust/rust_dma.rs
+
 DMA MAPPING BENCHMARK
 M:	Barry Song <baohua@kernel.org>
 M:	Qinxin Xia <xiaqinxin@huawei.com>
@@ -7877,40 +7884,6 @@ F:	include/linux/swiotlb.h
 F:	include/trace/events/dma.h
 F:	kernel/dma/
 
-DMA MAPPING & SCATTERLIST API [RUST]
-M:	Danilo Krummrich <dakr@kernel.org>
-R:	Abdiel Janulgue <abdiel.janulgue@gmail.com>
-R:	Daniel Almeida <daniel.almeida@collabora.com>
-R:	Robin Murphy <robin.murphy@arm.com>
-R:	Andreas Hindborg <a.hindborg@kernel.org>
-L:	driver-core@lists.linux.dev
-S:	Supported
-W:	https://rust-for-linux.com
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
-F:	rust/helpers/dma.c
-F:	rust/helpers/scatterlist.c
-F:	rust/kernel/dma.rs
-F:	rust/kernel/scatterlist.rs
-F:	samples/rust/rust_dma.rs
-
-DMA-BUF HEAPS FRAMEWORK
-M:	Sumit Semwal <sumit.semwal@linaro.org>
-R:	Benjamin Gaignard <benjamin.gaignard@collabora.com>
-R:	Brian Starkey <Brian.Starkey@arm.com>
-R:	John Stultz <jstultz@google.com>
-R:	T.J. Mercier <tjmercier@google.com>
-L:	linux-media@vger.kernel.org
-L:	dri-devel@lists.freedesktop.org
-L:	linaro-mm-sig@lists.linaro.org (moderated for non-subscribers)
-S:	Maintained
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/userspace-api/dma-buf-heaps.rst
-F:	drivers/dma-buf/dma-heap.c
-F:	drivers/dma-buf/heaps/*
-F:	include/linux/dma-heap.h
-F:	include/uapi/linux/dma-heap.h
-F:	tools/testing/selftests/dmabuf-heaps/
-
 DMC FREQUENCY DRIVER FOR SAMSUNG EXYNOS5422
 M:	Lukasz Luba <lukasz.luba@arm.com>
 L:	linux-pm@vger.kernel.org
@@ -8147,6 +8120,17 @@ S:	Maintained
 F:	drivers/soc/ti/smartreflex.c
 F:	include/linux/power/smartreflex.h
 
+DRM ACCEL DRIVER FOR ROCKCHIP NPU
+M:	Tomeu Vizoso <tomeu@tomeuvizoso.net>
+R:	Heiko Stuebner <heiko@sntech.de>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/accel/rocket/
+F:	Documentation/devicetree/bindings/npu/rockchip,rk3588-rknn-core.yaml
+F:	drivers/accel/rocket/
+F:	include/uapi/drm/rocket_accel.h
+
 DRM ACCEL DRIVERS FOR INTEL VPU
 M:	Karol Wachowski <karol.wachowski@linux.intel.com>
 M:	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
@@ -8158,16 +8142,14 @@ F:	Documentation/ABI/testing/sysfs-drive
 F:	drivers/accel/ivpu/
 F:	include/uapi/drm/ivpu_accel.h
 
-DRM ACCEL DRIVER FOR ROCKCHIP NPU
-M:	Tomeu Vizoso <tomeu@tomeuvizoso.net>
-R:	Heiko Stuebner <heiko@sntech.de>
+DRM AUTOMATED TESTING
+M:	Helen Koike <helen.fornazier@gmail.com>
+M:	Vignesh Raman <vignesh.raman@collabora.com>
 L:	dri-devel@lists.freedesktop.org
-S:	Supported
+S:	Maintained
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/accel/rocket/
-F:	Documentation/devicetree/bindings/npu/rockchip,rk3588-rknn-core.yaml
-F:	drivers/accel/rocket/
-F:	include/uapi/drm/rocket_accel.h
+F:	Documentation/gpu/automated_testing.rst
+F:	drivers/gpu/drm/ci/
 
 DRM COMPUTE ACCELERATORS DRIVERS AND FRAMEWORK
 M:	Oded Gabbay <ogabbay@kernel.org>
@@ -8422,46 +8404,6 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	Documentation/devicetree/bindings/display/panel/panel-mipi-dbi-spi.yaml
 F:	drivers/gpu/drm/tiny/panel-mipi-dbi.c
 
-DRM DRIVER for Qualcomm Adreno GPUs
-M:	Rob Clark <robin.clark@oss.qualcomm.com>
-R:	Sean Paul <sean@poorly.run>
-R:	Konrad Dybcio <konradybcio@kernel.org>
-R:	Akhil P Oommen <akhilpo@oss.qualcomm.com>
-L:	linux-arm-msm@vger.kernel.org
-L:	dri-devel@lists.freedesktop.org
-L:	freedreno@lists.freedesktop.org
-S:	Maintained
-B:	https://gitlab.freedesktop.org/drm/msm/-/issues
-T:	git https://gitlab.freedesktop.org/drm/msm.git
-F:	Documentation/devicetree/bindings/display/msm/gpu.yaml
-F:	Documentation/devicetree/bindings/display/msm/qcom,adreno-rgmu.yaml
-F:	Documentation/devicetree/bindings/opp/opp-v2-qcom-adreno.yaml
-F:	drivers/gpu/drm/msm/adreno/
-F:	drivers/gpu/drm/msm/msm_gpu.*
-F:	drivers/gpu/drm/msm/msm_gpu_devfreq.*
-F:	drivers/gpu/drm/msm/msm_ringbuffer.*
-F:	drivers/gpu/drm/msm/registers/adreno/
-F:	include/uapi/drm/msm_drm.h
-
-DRM DRIVER for Qualcomm display hardware
-M:	Rob Clark <robin.clark@oss.qualcomm.com>
-M:	Dmitry Baryshkov <lumag@kernel.org>
-R:	Abhinav Kumar <abhinav.kumar@linux.dev>
-R:	Jessica Zhang <jesszhan0024@gmail.com>
-R:	Sean Paul <sean@poorly.run>
-R:	Marijn Suijten <marijn.suijten@somainline.org>
-L:	linux-arm-msm@vger.kernel.org
-L:	dri-devel@lists.freedesktop.org
-L:	freedreno@lists.freedesktop.org
-S:	Maintained
-B:	https://gitlab.freedesktop.org/drm/msm/-/issues
-T:	git https://gitlab.freedesktop.org/drm/msm.git
-F:	Documentation/devicetree/bindings/display/msm/
-F:	drivers/gpu/drm/ci/xfails/msm*
-F:	drivers/gpu/drm/msm/
-F:	include/dt-bindings/clock/qcom,dsi-phy-28nm.h
-F:	include/uapi/drm/msm_drm.h
-
 DRM DRIVER FOR NOVATEK NT35510 PANELS
 M:	Linus Walleij <linusw@kernel.org>
 S:	Maintained
@@ -8531,18 +8473,6 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	drivers/gpu/drm/nouveau/
 F:	include/uapi/drm/nouveau_drm.h
 
-CORE DRIVER FOR NVIDIA GPUS [RUST]
-M:	Danilo Krummrich <dakr@kernel.org>
-M:	Alexandre Courbot <acourbot@nvidia.com>
-L:	nova-gpu@lists.linux.dev
-S:	Supported
-W:	https://rust-for-linux.com/nova-gpu-driver
-B:	https://gitlab.freedesktop.org/drm/nova/-/issues
-C:	irc://irc.oftc.net/nouveau
-T:	git https://gitlab.freedesktop.org/drm/rust/kernel.git drm-rust-next
-F:	Documentation/gpu/nova/
-F:	drivers/gpu/nova-core/
-
 DRM DRIVER FOR NVIDIA GPUS [RUST]
 M:	Danilo Krummrich <dakr@kernel.org>
 L:	nova-gpu@lists.linux.dev
@@ -8589,6 +8519,46 @@ W:	https://www.kraxel.org/blog/2014/10/q
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
 F:	drivers/gpu/drm/tiny/cirrus-qemu.c
 
+DRM DRIVER for Qualcomm Adreno GPUs
+M:	Rob Clark <robin.clark@oss.qualcomm.com>
+R:	Sean Paul <sean@poorly.run>
+R:	Konrad Dybcio <konradybcio@kernel.org>
+R:	Akhil P Oommen <akhilpo@oss.qualcomm.com>
+L:	linux-arm-msm@vger.kernel.org
+L:	dri-devel@lists.freedesktop.org
+L:	freedreno@lists.freedesktop.org
+S:	Maintained
+B:	https://gitlab.freedesktop.org/drm/msm/-/issues
+T:	git https://gitlab.freedesktop.org/drm/msm.git
+F:	Documentation/devicetree/bindings/display/msm/gpu.yaml
+F:	Documentation/devicetree/bindings/display/msm/qcom,adreno-rgmu.yaml
+F:	Documentation/devicetree/bindings/opp/opp-v2-qcom-adreno.yaml
+F:	drivers/gpu/drm/msm/adreno/
+F:	drivers/gpu/drm/msm/msm_gpu.*
+F:	drivers/gpu/drm/msm/msm_gpu_devfreq.*
+F:	drivers/gpu/drm/msm/msm_ringbuffer.*
+F:	drivers/gpu/drm/msm/registers/adreno/
+F:	include/uapi/drm/msm_drm.h
+
+DRM DRIVER for Qualcomm display hardware
+M:	Rob Clark <robin.clark@oss.qualcomm.com>
+M:	Dmitry Baryshkov <lumag@kernel.org>
+R:	Abhinav Kumar <abhinav.kumar@linux.dev>
+R:	Jessica Zhang <jesszhan0024@gmail.com>
+R:	Sean Paul <sean@poorly.run>
+R:	Marijn Suijten <marijn.suijten@somainline.org>
+L:	linux-arm-msm@vger.kernel.org
+L:	dri-devel@lists.freedesktop.org
+L:	freedreno@lists.freedesktop.org
+S:	Maintained
+B:	https://gitlab.freedesktop.org/drm/msm/-/issues
+T:	git https://gitlab.freedesktop.org/drm/msm.git
+F:	Documentation/devicetree/bindings/display/msm/
+F:	drivers/gpu/drm/ci/xfails/msm*
+F:	drivers/gpu/drm/msm/
+F:	include/dt-bindings/clock/qcom,dsi-phy-28nm.h
+F:	include/uapi/drm/msm_drm.h
+
 DRM DRIVER FOR QXL VIRTUAL GPU
 M:	Dave Airlie <airlied@redhat.com>
 M:	Gerd Hoffmann <kraxel@redhat.com>
@@ -8675,13 +8645,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/display/sharp,ls010b7dh04.yaml
 F:	drivers/gpu/drm/tiny/sharp-memory.c
 
-DRM DRIVER FOR SITRONIX ST7586 PANELS
-M:	David Lechner <david@lechnology.com>
-S:	Maintained
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/devicetree/bindings/display/sitronix,st7586.yaml
-F:	drivers/gpu/drm/sitronix/st7586.c
-
 DRM DRIVER FOR SITRONIX ST7571 PANELS
 M:	Marcus Folkesson <marcus.folkesson@gmail.com>
 S:	Maintained
@@ -8692,6 +8655,13 @@ F:	drivers/gpu/drm/sitronix/st7571-spi.c
 F:	drivers/gpu/drm/sitronix/st7571.c
 F:	drivers/gpu/drm/sitronix/st7571.h
 
+DRM DRIVER FOR SITRONIX ST7586 PANELS
+M:	David Lechner <david@lechnology.com>
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/devicetree/bindings/display/sitronix,st7586.yaml
+F:	drivers/gpu/drm/sitronix/st7586.c
+
 DRM DRIVER FOR SITRONIX ST7701 PANELS
 M:	Jagan Teki <jagan@amarulasolutions.com>
 S:	Maintained
@@ -8828,6 +8798,22 @@ F:	include/drm/
 F:	include/linux/vga*
 F:	include/uapi/drm/
 
+DRM DRIVERS AND COMMON INFRASTRUCTURE [RUST]
+M:	Danilo Krummrich <dakr@kernel.org>
+M:	Alice Ryhl <aliceryhl@google.com>
+S:	Supported
+W:	https://drm.pages.freedesktop.org/maintainer-tools/drm-rust.html
+T:	git https://gitlab.freedesktop.org/drm/rust/kernel.git
+F:	drivers/gpu/drm/nova/
+F:	drivers/gpu/drm/tyr/
+F:	drivers/gpu/nova-core/
+F:	rust/helpers/dma_fence.c
+F:	rust/helpers/gpu.c
+F:	rust/kernel/dma_buf/
+F:	rust/kernel/drm/
+F:	rust/kernel/gpu.rs
+F:	rust/kernel/gpu/
+
 DRM DRIVERS AND MISC GPU PATCHES
 M:	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
 M:	Maxime Ripard <mripard@kernel.org>
@@ -8857,22 +8843,6 @@ X:	drivers/gpu/drm/tegra/
 X:	drivers/gpu/drm/tyr/
 X:	drivers/gpu/drm/xe/
 
-DRM DRIVERS AND COMMON INFRASTRUCTURE [RUST]
-M:	Danilo Krummrich <dakr@kernel.org>
-M:	Alice Ryhl <aliceryhl@google.com>
-S:	Supported
-W:	https://drm.pages.freedesktop.org/maintainer-tools/drm-rust.html
-T:	git https://gitlab.freedesktop.org/drm/rust/kernel.git
-F:	drivers/gpu/drm/nova/
-F:	drivers/gpu/drm/tyr/
-F:	drivers/gpu/nova-core/
-F:	rust/helpers/dma_fence.c
-F:	rust/helpers/gpu.c
-F:	rust/kernel/dma_buf/
-F:	rust/kernel/drm/
-F:	rust/kernel/gpu.rs
-F:	rust/kernel/gpu/
-
 DRM DRIVERS FOR ALLWINNER A10
 M:	Chen-Yu Tsai <wens@kernel.org>
 L:	dri-devel@lists.freedesktop.org
@@ -8951,14 +8921,6 @@ F:	Documentation/devicetree/bindings/dis
 F:	drivers/gpu/drm/imx/ipuv3/
 F:	drivers/gpu/ipu-v3/
 
-DRM DRIVERS FOR FREESCALE IMX8 DISPLAY CONTROLLER
-M:	Liu Ying <victor.liu@nxp.com>
-L:	dri-devel@lists.freedesktop.org
-S:	Maintained
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/devicetree/bindings/display/imx/fsl,imx8qxp-dc*.yaml
-F:	drivers/gpu/drm/imx/dc/
-
 DRM DRIVERS FOR FREESCALE IMX BRIDGE
 M:	Liu Ying <victor.liu@nxp.com>
 L:	dri-devel@lists.freedesktop.org
@@ -8969,6 +8931,14 @@ F:	Documentation/devicetree/bindings/dis
 F:	Documentation/devicetree/bindings/display/bridge/fsl,imx8qxp-pxl2dpi.yaml
 F:	drivers/gpu/drm/bridge/imx/
 
+DRM DRIVERS FOR FREESCALE IMX8 DISPLAY CONTROLLER
+M:	Liu Ying <victor.liu@nxp.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	Documentation/devicetree/bindings/display/imx/fsl,imx8qxp-dc*.yaml
+F:	drivers/gpu/drm/imx/dc/
+
 DRM DRIVERS FOR GMA500 (Poulsbo, Moorestown and derivative chipsets)
 M:	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
 L:	dri-devel@lists.freedesktop.org
@@ -9227,19 +9197,6 @@ F:	drivers/gpu/drm/scheduler/
 F:	include/drm/gpu_scheduler.h
 F:	include/drm/spsc_queue.h
 
-DRM GPUVM
-M:	Danilo Krummrich <dakr@kernel.org>
-R:	Matthew Brost <matthew.brost@intel.com>
-R:	Thomas Hellström <thomas.hellstrom@linux.intel.com>
-R:	Alice Ryhl <aliceryhl@google.com>
-L:	dri-devel@lists.freedesktop.org
-S:	Supported
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	drivers/gpu/drm/drm_gpuvm.c
-F:	include/drm/drm_gpuvm.h
-F:	rust/helpers/drm_gpuvm.c
-F:	rust/kernel/drm/gpuvm/
-
 DRM GPUSVM
 M:	Matthew Brost <matthew.brost@intel.com>
 R:	Thomas Hellström <thomas.hellstrom@linux.intel.com>
@@ -9255,6 +9212,19 @@ F:	include/drm/drm_gpusvm.h
 F:	include/drm/drm_pagemap.h
 F:	include/drm/drm_pagemap_util.h
 
+DRM GPUVM
+M:	Danilo Krummrich <dakr@kernel.org>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Thomas Hellström <thomas.hellstrom@linux.intel.com>
+R:	Alice Ryhl <aliceryhl@google.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	drivers/gpu/drm/drm_gpuvm.c
+F:	include/drm/drm_gpuvm.h
+F:	rust/helpers/drm_gpuvm.c
+F:	rust/kernel/drm/gpuvm/
+
 DRM LOG
 M:	Jocelyn Falempe <jfalempe@redhat.com>
 M:	Javier Martinez Canillas <javierm@redhat.com>
@@ -9331,31 +9301,6 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	drivers/gpu/drm/ttm/
 F:	include/drm/ttm/
 
-GPU BUDDY ALLOCATOR
-M:	Matthew Auld <matthew.auld@intel.com>
-M:	Arun Pravin <arunpravin.paneerselvam@amd.com>
-R:	Joel Fernandes <joelagnelf@nvidia.com>
-L:	dri-devel@lists.freedesktop.org
-S:	Maintained
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	drivers/gpu/buddy.c
-F:	drivers/gpu/drm/drm_buddy.c
-F:	drivers/gpu/tests/gpu_buddy_test.c
-F:	include/drm/drm_buddy.h
-F:	include/linux/gpu_buddy.h
-F:	rust/helpers/gpu.c
-F:	rust/kernel/gpu.rs
-F:	rust/kernel/gpu/
-
-DRM AUTOMATED TESTING
-M:	Helen Koike <helen.fornazier@gmail.com>
-M:	Vignesh Raman <vignesh.raman@collabora.com>
-L:	dri-devel@lists.freedesktop.org
-S:	Maintained
-T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
-F:	Documentation/gpu/automated_testing.rst
-F:	drivers/gpu/drm/ci/
-
 DSBR100 USB FM RADIO DRIVER
 M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
@@ -9551,6 +9496,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/filesystems/ecryptfs.rst
 F:	fs/ecryptfs/
 
+EDAC-A72
+M:	Vijay Balakrishna <vijayb@linux.microsoft.com>
+M:	Tyler Hicks <code@tyhicks.com>
+L:	linux-edac@vger.kernel.org
+S:	Supported
+F:	drivers/edac/a72_edac.c
+
 EDAC-AMD64
 M:	Yazen Ghannam <yazen.ghannam@amd.com>
 L:	linux-edac@vger.kernel.org
@@ -9605,13 +9557,6 @@ F:	Documentation/driver-api/edac.rst
 F:	drivers/edac/
 F:	include/linux/edac.h
 
-EDAC-A72
-M:	Vijay Balakrishna <vijayb@linux.microsoft.com>
-M:	Tyler Hicks <code@tyhicks.com>
-L:	linux-edac@vger.kernel.org
-S:	Supported
-F:	drivers/edac/a72_edac.c
-
 EDAC-DMC520
 M:	Lei Wang <lewan@microsoft.com>
 L:	linux-edac@vger.kernel.org
@@ -10836,6 +10781,16 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/freescale/fs_enet/
 
+FREESCALE SOC LPC32XX SOUND DRIVERS
+M:	J.M.B. Downing <jonathan.downing@nautel.com>
+M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
+R:	Vladimir Zapolskiy <vz@mleia.com>
+L:	linux-sound@vger.kernel.org
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/sound/nxp,lpc3220-i2s.yaml
+F:	sound/soc/fsl/lpc3xxx-*
+
 FREESCALE SOC SOUND DRIVERS
 M:	Shengjiu Wang <shengjiu.wang@gmail.com>
 M:	Xiubo Li <Xiubo.Lee@gmail.com>
@@ -10847,16 +10802,6 @@ S:	Maintained
 F:	sound/soc/fsl/fsl*
 F:	sound/soc/fsl/imx*
 
-FREESCALE SOC LPC32XX SOUND DRIVERS
-M:	J.M.B. Downing <jonathan.downing@nautel.com>
-M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
-R:	Vladimir Zapolskiy <vz@mleia.com>
-L:	linux-sound@vger.kernel.org
-L:	linuxppc-dev@lists.ozlabs.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/sound/nxp,lpc3220-i2s.yaml
-F:	sound/soc/fsl/lpc3xxx-*
-
 FREESCALE SOC SOUND QMC DRIVER
 M:	Herve Codina <herve.codina@bootlin.com>
 L:	linux-sound@vger.kernel.org
@@ -10900,17 +10845,6 @@ F:	fs/crypto/
 F:	include/linux/fscrypt.h
 F:	include/uapi/linux/fscrypt.h
 
-FSI SUBSYSTEM
-M:	Eddie James <eajames@linux.ibm.com>
-R:	Ninad Palsule <ninad@linux.ibm.com>
-L:	linux-fsi@lists.ozlabs.org
-S:	Supported
-Q:	http://patchwork.ozlabs.org/project/linux-fsi/list/
-F:	Documentation/devicetree/bindings/fsi/
-F:	drivers/fsi/
-F:	include/linux/fsi*.h
-F:	include/trace/events/fsi*.h
-
 FSI-ATTACHED I2C DRIVER
 M:	Eddie James <eajames@linux.ibm.com>
 L:	linux-i2c@vger.kernel.org
@@ -10926,6 +10860,17 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
 F:	drivers/spi/spi-fsi.c
 
+FSI SUBSYSTEM
+M:	Eddie James <eajames@linux.ibm.com>
+R:	Ninad Palsule <ninad@linux.ibm.com>
+L:	linux-fsi@lists.ozlabs.org
+S:	Supported
+Q:	http://patchwork.ozlabs.org/project/linux-fsi/list/
+F:	Documentation/devicetree/bindings/fsi/
+F:	drivers/fsi/
+F:	include/linux/fsi*.h
+F:	include/trace/events/fsi*.h
+
 FSNOTIFY: FILESYSTEM NOTIFICATION INFRASTRUCTURE
 M:	Jan Kara <jack@suse.cz>
 R:	Amir Goldstein <amir73il@gmail.com>
@@ -11041,20 +10986,6 @@ F:	kernel/futex/*
 F:	tools/perf/bench/futex*
 F:	tools/testing/selftests/futex/
 
-FWCTL SUBSYSTEM
-M:	Dave Jiang <dave.jiang@intel.com>
-M:	Jason Gunthorpe <jgg@nvidia.com>
-M:	Saeed Mahameed <saeedm@nvidia.com>
-M:	Zhi Wang <zhiw@nvidia.com> (RUST)
-R:	Jonathan Cameron <jic23@kernel.org>
-S:	Maintained
-F:	Documentation/userspace-api/fwctl/
-F:	drivers/fwctl/
-F:	include/linux/fwctl.h
-F:	include/uapi/fwctl/
-F:	rust/helpers/fwctl.c
-F:	rust/kernel/fwctl.rs
-
 FWCTL BNXT DRIVER
 M:	Pavan Chebbi <pavan.chebbi@broadcom.com>
 L:	linux-kernel@vger.kernel.org
@@ -11074,6 +11005,20 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/fwctl/pds/
 
+FWCTL SUBSYSTEM
+M:	Dave Jiang <dave.jiang@intel.com>
+M:	Jason Gunthorpe <jgg@nvidia.com>
+M:	Saeed Mahameed <saeedm@nvidia.com>
+M:	Zhi Wang <zhiw@nvidia.com> (RUST)
+R:	Jonathan Cameron <jic23@kernel.org>
+S:	Maintained
+F:	Documentation/userspace-api/fwctl/
+F:	drivers/fwctl/
+F:	include/linux/fwctl.h
+F:	include/uapi/fwctl/
+F:	rust/helpers/fwctl.c
+F:	rust/kernel/fwctl.rs
+
 GALAXYCORE GC0308 CAMERA SENSOR DRIVER
 M:	Sebastian Reichel <sre@kernel.org>
 L:	linux-media@vger.kernel.org
@@ -11500,6 +11445,22 @@ F:	drivers/gpio/gpiolib-cdev.c
 F:	include/uapi/linux/gpio.h
 F:	tools/gpio/
 
+GPU BUDDY ALLOCATOR
+M:	Matthew Auld <matthew.auld@intel.com>
+M:	Arun Pravin <arunpravin.paneerselvam@amd.com>
+R:	Joel Fernandes <joelagnelf@nvidia.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Maintained
+T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
+F:	drivers/gpu/buddy.c
+F:	drivers/gpu/drm/drm_buddy.c
+F:	drivers/gpu/tests/gpu_buddy_test.c
+F:	include/drm/drm_buddy.h
+F:	include/linux/gpu_buddy.h
+F:	rust/helpers/gpu.c
+F:	rust/kernel/gpu.rs
+F:	rust/kernel/gpu/
+
 GRETH 10/100/1G Ethernet MAC device driver
 M:	Andreas Larsson <andreas@gaisler.com>
 L:	netdev@vger.kernel.org
@@ -11523,6 +11484,13 @@ F:	drivers/staging/greybus/audio_manager
 F:	drivers/staging/greybus/audio_module.c
 F:	drivers/staging/greybus/audio_topology.c
 
+GREYBUS BEAGLEPLAY DRIVERS
+M:	Ayush Singh <ayushdevel1325@gmail.com>
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/ti,cc1352p7.yaml
+F:	drivers/greybus/gb-beagleplay.c
+
 GREYBUS FW/HID/SPI PROTOCOLS DRIVERS
 M:	Viresh Kumar <vireshk@kernel.org>
 S:	Maintained
@@ -11555,13 +11523,6 @@ F:	drivers/staging/greybus/sdio.c
 F:	drivers/staging/greybus/spi.c
 F:	drivers/staging/greybus/spilib.c
 
-GREYBUS BEAGLEPLAY DRIVERS
-M:	Ayush Singh <ayushdevel1325@gmail.com>
-L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
-S:	Maintained
-F:	Documentation/devicetree/bindings/net/ti,cc1352p7.yaml
-F:	drivers/greybus/gb-beagleplay.c
-
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 M:	Alex Elder <elder@kernel.org>
@@ -11926,31 +11887,6 @@ F:	kernel/time/timer_list.c
 F:	kernel/time/timer_migration.*
 F:	tools/testing/selftests/timers/
 
-HITRON HAC300S PSU DRIVER
-M:	Vasileios Amoiridis <vasileios.amoiridis@cern.ch>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/hac300s.rst
-F:	drivers/hwmon/pmbus/hac300s.c
-
-DELAY, SLEEP, TIMEKEEPING, TIMERS [RUST]
-M:	Andreas Hindborg <a.hindborg@kernel.org>
-R:	Boqun Feng <boqun@kernel.org>
-R:	FUJITA Tomonori <fujita.tomonori@gmail.com>
-R:	Frederic Weisbecker <frederic@kernel.org>
-R:	Lyude Paul <lyude@redhat.com>
-R:	Thomas Gleixner <tglx@kernel.org>
-R:	Anna-Maria Behnsen <anna-maria@linutronix.de>
-R:	John Stultz <jstultz@google.com>
-R:	Stephen Boyd <sboyd@kernel.org>
-L:	rust-for-linux@vger.kernel.org
-S:	Supported
-W:	https://rust-for-linux.com
-B:	https://github.com/Rust-for-Linux/linux/issues
-T:	git https://github.com/Rust-for-Linux/linux.git timekeeping-next
-F:	rust/kernel/time.rs
-F:	rust/kernel/time/
-
 HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 M:	HighPoint Linux Team <linux@highpoint-tech.com>
 S:	Supported
@@ -12033,11 +11969,6 @@ F:	Documentation/ABI/testing/sysfs-devic
 F:	drivers/soc/hisilicon/kunpeng_hccs.c
 F:	drivers/soc/hisilicon/kunpeng_hccs.h
 
-HISILICON SOC HHA DRIVER
-M:	Yushan Wang <wangyushan12@huawei.com>
-S:	Maintained
-F:	drivers/cache/hisi_soc_hha.c
-
 HISILICON LPC BUS DRIVER
 M:	Jay Fang <f.fangjian@huawei.com>
 S:	Maintained
@@ -12045,19 +11976,19 @@ W:	http://www.hisilicon.com
 F:	Documentation/devicetree/bindings/arm/hisilicon/low-pin-count.yaml
 F:	drivers/bus/hisi_lpc.c
 
-HISILICON NETWORK SUBSYSTEM 3 DRIVER (HNS3)
-M:	Jian Shen <shenjian15@huawei.com>
+HISILICON NETWORK HIBMCGE DRIVER
 M:	Jijie Shao <shaojijie@huawei.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-W:	http://www.hisilicon.com
-F:	drivers/net/ethernet/hisilicon/hns3/
+F:	drivers/net/ethernet/hisilicon/hibmcge/
 
-HISILICON NETWORK HIBMCGE DRIVER
+HISILICON NETWORK SUBSYSTEM 3 DRIVER (HNS3)
+M:	Jian Shen <shenjian15@huawei.com>
 M:	Jijie Shao <shaojijie@huawei.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/hisilicon/hibmcge/
+W:	http://www.hisilicon.com
+F:	drivers/net/ethernet/hisilicon/hns3/
 
 HISILICON NETWORK SUBSYSTEM DRIVER
 M:	Jian Shen <shenjian15@huawei.com>
@@ -12124,6 +12055,11 @@ F:	drivers/crypto/hisilicon/sec2/sec_cry
 F:	drivers/crypto/hisilicon/sec2/sec_crypto.h
 F:	drivers/crypto/hisilicon/sec2/sec_main.c
 
+HISILICON SOC HHA DRIVER
+M:	Yushan Wang <wangyushan12@huawei.com>
+S:	Maintained
+F:	drivers/cache/hisi_soc_hha.c
+
 HISILICON SPI Controller DRIVER FOR KUNPENG SOCS
 M:	Yang Shen <shenyang39@huawei.com>
 L:	linux-spi@vger.kernel.org
@@ -12164,16 +12100,12 @@ S:	Maintained
 F:	Documentation/ABI/testing/debugfs-hisi-zip
 F:	drivers/crypto/hisilicon/zip/
 
-MEMORY MANAGEMENT - HMM (Heterogeneous Memory Management)
-M:	Jason Gunthorpe <jgg@nvidia.com>
-M:	Leon Romanovsky <leonro@nvidia.com>
-L:	linux-mm@kvack.org
+HITRON HAC300S PSU DRIVER
+M:	Vasileios Amoiridis <vasileios.amoiridis@cern.ch>
+L:	linux-hwmon@vger.kernel.org
 S:	Maintained
-F:	Documentation/mm/hmm.rst
-F:	include/linux/hmm*
-F:	lib/test_hmm*
-F:	mm/hmm*
-F:	tools/testing/selftests/mm/*hmm*
+F:	Documentation/hwmon/hac300s.rst
+F:	drivers/hwmon/pmbus/hac300s.c
 
 HONEYWELL ABP2030PA PRESSURE SENSOR SERIES IIO DRIVER
 M:	Petre Rodan <petre.rodan@subdimension.ro>
@@ -12305,13 +12237,6 @@ L:	linux-hwmon@vger.kernel.org
 S:	Maintained
 F:	drivers/hwmon/htu31.c
 
-HUAWEI ETHERNET DRIVER
-M:	Cai Huoqing <cai.huoqing@linux.dev>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
-F:	drivers/net/ethernet/huawei/hinic/
-
 HUAWEI 3RD GEN ETHERNET DRIVER
 M:	Fan Gong <gongfan1@huawei.com>
 L:	netdev@vger.kernel.org
@@ -12319,6 +12244,13 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/huawei/hinic3.rst
 F:	drivers/net/ethernet/huawei/hinic3/
 
+HUAWEI ETHERNET DRIVER
+M:	Cai Huoqing <cai.huoqing@linux.dev>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
+F:	drivers/net/ethernet/huawei/hinic/
+
 HUAWEI MATEBOOK E GO EMBEDDED CONTROLLER DRIVER
 M:	Pengyu Luo <mitltlatltl@gmail.com>
 S:	Maintained
@@ -12328,31 +12260,15 @@ F:	drivers/power/supply/huawei-gaokun-ba
 F:	drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
 F:	include/linux/platform_data/huawei-gaokun-ec.h
 
-MEMORY MANAGEMENT - HUGETLB
-M:	Muchun Song <muchun.song@linux.dev>
-M:	Oscar Salvador <osalvador@suse.de>
-R:	David Hildenbrand <david@kernel.org>
-L:	linux-mm@kvack.org
+HUNG TASK DETECTOR
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Lance Yang <lance.yang@linux.dev>
+R:	Masami Hiramatsu <mhiramat@kernel.org>
+R:	Petr Mladek <pmladek@suse.com>
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
-F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
-F:	Documentation/admin-guide/mm/hugetlbpage.rst
-F:	Documentation/mm/hugetlbfs_reserv.rst
-F:	Documentation/mm/vmemmap_dedup.rst
-F:	fs/hugetlbfs/
-F:	include/linux/hugetlb*
-F:	include/linux/vmemmap-optimization.h
-F:	include/trace/events/hugetlbfs.h
-F:	mm/hugetlb.c
-F:	mm/hugetlb_cgroup.c
-F:	mm/hugetlb_cma.c
-F:	mm/hugetlb_cma.h
-F:	mm/hugetlb_internal.h
-F:	mm/hugetlb_sysctl.c
-F:	mm/hugetlb_sysfs.c
-F:	mm/hugetlb_vmemmap.c
-F:	mm/hugetlb_vmemmap.h
-F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+F:	include/linux/hung_task.h
+F:	kernel/hung_task.c
 
 HVA ST MEDIA DRIVER
 M:	Jean-Christophe Trotin <jean-christophe.trotin@foss.st.com>
@@ -12362,18 +12278,6 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/platform/st/sti/hva
 
-MEMORY MANAGEMENT - HWPOISON MEMORY FAILURE HANDLING
-M:	Miaohe Lin <linmiaohe@huawei.com>
-R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/ABI/testing/sysfs-memory-page-offline
-F:	include/linux/memory-failure.h
-F:	include/trace/events/memory-failure.h
-F:	mm/hwpoison-inject.c
-F:	mm/memory-failure.c
-F:	tools/testing/selftests/mm/memory-failure.c
-
 HYCON HY46XX TOUCHSCREEN SUPPORT
 M:	Giulio Benetti <giulio.benetti@benettiengineering.com>
 L:	linux-input@vger.kernel.org
@@ -12465,16 +12369,6 @@ L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
 F:	drivers/tty/hvc/
 
-HUNG TASK DETECTOR
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Lance Yang <lance.yang@linux.dev>
-R:	Masami Hiramatsu <mhiramat@kernel.org>
-R:	Petr Mladek <pmladek@suse.com>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-F:	include/linux/hung_task.h
-F:	kernel/hung_task.c
-
 I2C ACPI SUPPORT
 M:	Mika Westerberg <westeri@kernel.org>
 L:	linux-i2c@vger.kernel.org
@@ -12627,6 +12521,12 @@ L:	linux-i2c@vger.kernel.org
 F:	Documentation/i2c/busses/i2c-ismt.rst
 F:	drivers/i2c/busses/i2c-ismt.c
 
+I2C/SMBUS STUB DRIVER
+M:	Jean Delvare <jdelvare@suse.com>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	drivers/i2c/i2c-stub.c
+
 I2C/SMBUS ZHAOXIN DRIVER
 M:	Hans Hu <hanshu@zhaoxin.com>
 L:	linux-i2c@vger.kernel.org
@@ -12635,11 +12535,11 @@ W:	https://www.zhaoxin.com
 F:	drivers/i2c/busses/i2c-viai2c-common.c
 F:	drivers/i2c/busses/i2c-viai2c-zhaoxin.c
 
-I2C/SMBUS STUB DRIVER
-M:	Jean Delvare <jdelvare@suse.com>
-L:	linux-i2c@vger.kernel.org
+I3C DRIVER FOR ANALOG DEVICES I3C CONTROLLER IP
+M:	Jorge Marques <jorge.marques@analog.com>
 S:	Maintained
-F:	drivers/i2c/i2c-stub.c
+F:	Documentation/devicetree/bindings/i3c/adi,i3c-master.yaml
+F:	drivers/i3c/master/adi-i3c-master.c
 
 I3C DRIVER FOR ASPEED AST2600
 M:	Jeremy Kerr <jk@codeconstruct.com.au>
@@ -12647,12 +12547,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/i3c/aspeed,ast2600-i3c.yaml
 F:	drivers/i3c/master/ast2600-i3c-master.c
 
-I3C DRIVER FOR ANALOG DEVICES I3C CONTROLLER IP
-M:	Jorge Marques <jorge.marques@analog.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/i3c/adi,i3c-master.yaml
-F:	drivers/i3c/master/adi-i3c-master.c
-
 I3C DRIVER FOR CADENCE I3C MASTER IP
 M:	Przemysław Gaj <pgaj@cadence.com>
 S:	Maintained
@@ -12858,12 +12752,6 @@ F:	include/net/nl802154.h
 F:	net/ieee802154/
 F:	net/mac802154/
 
-Intel VIRTIO DATA PATH ACCELERATOR
-M:	Zhu Lingshan <lingshan.zhu@kernel.org>
-L:	virtualization@lists.linux.dev
-S:	Supported
-F:	drivers/vdpa/ifcvf/
-
 IFE PROTOCOL
 M:	Yotam Gigi <yotam.gi@gmail.com>
 M:	Jamal Hadi Salim <jhs@mojatatu.com>
@@ -12899,6 +12787,13 @@ F:	Documentation/ABI/testing/debugfs-iio
 F:	drivers/iio/industrialio-backend.c
 F:	include/linux/iio/backend.h
 
+IIO CORE KUNIT TESTS
+M:	Rodrigo Alencar <rodrigo.alencar@analog.com>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	drivers/iio/test/iio-test-channel-prefix.c
+F:	drivers/iio/test/iio-test-format.c
+
 IIO DIGITAL POTENTIOMETER DAC
 M:	Peter Rosin <peda@lysator.liu.se>
 L:	linux-iio@vger.kernel.org
@@ -12956,13 +12851,6 @@ F:	include/dt-bindings/iio/
 F:	include/linux/iio/
 F:	tools/iio/
 
-IIO CORE KUNIT TESTS
-M:	Rodrigo Alencar <rodrigo.alencar@analog.com>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	drivers/iio/test/iio-test-channel-prefix.c
-F:	drivers/iio/test/iio-test-format.c
-
 IIO UNIT CONVERTER
 M:	Peter Rosin <peda@lysator.liu.se>
 L:	linux-iio@vger.kernel.org
@@ -12990,6 +12878,10 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/auxdisplay/img,ascii-lcd.yaml
 F:	drivers/auxdisplay/img-ascii-lcd.c
 
+IMGTEC IR DECODER DRIVER
+S:	Orphan
+F:	drivers/media/rc/img-ir/
+
 IMGTEC JPEG ENCODER DRIVER
 M:	Devarsh Thakkar <devarsht@ti.com>
 L:	linux-media@vger.kernel.org
@@ -12997,10 +12889,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/media/img,e5010-jpeg-enc.yaml
 F:	drivers/media/platform/imagination/e5010*
 
-IMGTEC IR DECODER DRIVER
-S:	Orphan
-F:	drivers/media/rc/img-ir/
-
 IMGTEC POWERVR DRM DRIVER
 M:	Alessio Belle <alessio.belle@imgtec.com>
 M:	Luigi Santivetti <luigi.santivetti@imgtec.com>
@@ -13298,6 +13186,13 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	arch/x86/include/asm/intel-family.h
 
+INTEL CRPS COMMON REDUNDANT PSU DRIVER
+M:	Ninad Palsule <ninad@linux.ibm.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/hwmon/crps.rst
+F:	drivers/hwmon/pmbus/crps.c
+
 INTEL DISCRETE GRAPHICS NVM MTD DRIVER
 M:	Alexander Usyskin <alexander.usyskin@intel.com>
 L:	linux-mtd@lists.infradead.org
@@ -13718,14 +13613,6 @@ F:	drivers/platform/x86/intel/sdsi.c
 F:	tools/arch/x86/intel_sdsi/
 F:	tools/testing/selftests/drivers/sdsi/
 
-INTEL SILICON SECURITY ENGINE INTERFACE (ISSEI)
-M:	Alexander Usyskin <alexander.usyskin@intel.com>
-S:	Supported
-F:	Documentation/ABI/testing/sysfs-class-issei
-F:	Documentation/driver-api/issei/issei.rst
-F:	drivers/misc/issei/
-F:	include/uapi/linux/issei.h
-
 INTEL SGX
 M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Dave Hansen <dave.hansen@linux.intel.com>
@@ -13741,6 +13628,14 @@ F:	arch/x86/kernel/cpu/sgx/*
 F:	tools/testing/selftests/sgx/*
 K:	\bSGX_
 
+INTEL SILICON SECURITY ENGINE INTERFACE (ISSEI)
+M:	Alexander Usyskin <alexander.usyskin@intel.com>
+S:	Supported
+F:	Documentation/ABI/testing/sysfs-class-issei
+F:	Documentation/driver-api/issei/issei.rst
+F:	drivers/misc/issei/
+F:	include/uapi/linux/issei.h
+
 INTEL SKYLAKE INT3472 ACPI DEVICE DRIVER
 M:	Daniel Scally <dan.scally@ideasonboard.com>
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
@@ -13815,12 +13710,26 @@ S:	Supported
 F:	drivers/platform/x86/intel/vsec.c
 F:	include/linux/intel_vsec.h
 
+Intel VIRTIO DATA PATH ACCELERATOR
+M:	Zhu Lingshan <lingshan.zhu@kernel.org>
+L:	virtualization@lists.linux.dev
+S:	Supported
+F:	drivers/vdpa/ifcvf/
+
 INTEL VIRTUAL BUTTON DRIVER
 M:	AceLan Kao <acelan.kao@canonical.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/intel/vbtn.c
 
+INTEL VISION SENSING CONTROLLER DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+R:	Lixu Zhang <lixu.zhang@intel.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+T:	git git://linuxtv.org/media.git
+F:	drivers/media/pci/intel/ivsc/
+
 INTEL WIRELESS 3945ABG/BG, 4965AGN (iwlegacy)
 M:	Stanislaw Gruszka <stf_xl@wp.pl>
 L:	linux-wireless@vger.kernel.org
@@ -13835,14 +13744,6 @@ W:	https://wireless.docs.kernel.org/en/l
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git/
 F:	drivers/net/wireless/intel/iwlwifi/
 
-INTEL VISION SENSING CONTROLLER DRIVER
-M:	Sakari Ailus <sakari.ailus@linux.intel.com>
-R:	Lixu Zhang <lixu.zhang@intel.com>
-L:	linux-media@vger.kernel.org
-S:	Maintained
-T:	git git://linuxtv.org/media.git
-F:	drivers/media/pci/intel/ivsc/
-
 INTEL WMI SLIM BOOTLOADER (SBL) FIRMWARE UPDATE DRIVER
 S:	Orphan
 W:	https://slimbootloader.github.io/security/firmware-update.html
@@ -13951,6 +13852,37 @@ W:	https://invensense.tdk.com/
 F:	Documentation/devicetree/bindings/iio/imu/invensense,mpu6050.yaml
 F:	drivers/iio/imu/inv_mpu6050/
 
+IO_URING
+M:	Jens Axboe <axboe@kernel.dk>
+L:	io-uring@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git
+F:	include/linux/io_uring/
+F:	include/linux/io_uring.h
+F:	include/linux/io_uring_types.h
+F:	include/trace/events/io_uring.h
+F:	include/uapi/linux/io_uring.h
+F:	include/uapi/linux/io_uring/
+F:	io_uring/
+
+IO_URING BPF-OPS
+M:	Pavel Begunkov <asml.silence@gmail.com>
+L:	io-uring@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
+S:	Maintained
+F:	io_uring/bpf-ops.*
+F:	io_uring/loop.*
+
+IO_URING ZCRX
+M:	Pavel Begunkov <asml.silence@gmail.com>
+L:	io-uring@vger.kernel.org
+L:	netdev@vger.kernel.org
+T:	git https://github.com/isilence/linux.git zcrx/for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
+S:	Maintained
+F:	io_uring/zcrx.*
+
 IOC3 ETHERNET DRIVER
 M:	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
 L:	linux-mips@vger.kernel.org
@@ -14001,37 +13933,6 @@ S:	Maintained
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
 F:	include/linux/iosys-map.h
 
-IO_URING
-M:	Jens Axboe <axboe@kernel.dk>
-L:	io-uring@vger.kernel.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git
-F:	include/linux/io_uring/
-F:	include/linux/io_uring.h
-F:	include/linux/io_uring_types.h
-F:	include/trace/events/io_uring.h
-F:	include/uapi/linux/io_uring.h
-F:	include/uapi/linux/io_uring/
-F:	io_uring/
-
-IO_URING ZCRX
-M:	Pavel Begunkov <asml.silence@gmail.com>
-L:	io-uring@vger.kernel.org
-L:	netdev@vger.kernel.org
-T:	git https://github.com/isilence/linux.git zcrx/for-next
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
-S:	Maintained
-F:	io_uring/zcrx.*
-
-IO_URING BPF-OPS
-M:	Pavel Begunkov <asml.silence@gmail.com>
-L:	io-uring@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
-S:	Maintained
-F:	io_uring/bpf-ops.*
-F:	io_uring/loop.*
-
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
@@ -14458,6 +14359,10 @@ L:	kernel-janitors@vger.kernel.org
 S:	Odd Fixes
 W:	http://kernelnewbies.org/KernelJanitors
 
+KERNEL NFSD BLOCK and SCSI LAYOUT DRIVER
+R:	Christoph Hellwig <hch@lst.de>
+F:	fs/nfsd/blocklayout*
+
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	Chuck Lever <cel@kernel.org>
 M:	Jeff Layton <jlayton@kernel.org>
@@ -14489,10 +14394,6 @@ F:	net/sunrpc/
 F:	tools/net/sunrpc/
 F:	tools/testing/selftests/nfsd/
 
-KERNEL NFSD BLOCK and SCSI LAYOUT DRIVER
-R:	Christoph Hellwig <hch@lst.de>
-F:	fs/nfsd/blocklayout*
-
 KERNEL PACMAN PACKAGING (in addition to generic KERNEL BUILD)
 M:	Thomas Weißschuh <linux@weissschuh.net>
 R:	Christian Heusel <christian@heusel.eu>
@@ -14574,6 +14475,22 @@ F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
 F:	virt/kvm/*
 
+KERNEL VIRTUAL MACHINE for arm-on-s390 (KVM/s390)
+R:	Steffen Eiden <seiden@linux.ibm.com>
+R:	Andreas Grapentin <gra@linux.ibm.com>
+R:	Marc Zyngier <maz@kernel.org>
+L:	kvm@vger.kernel.org
+L:	linux-s390@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
+F:	arch/s390/include/arm64/
+F:	arch/s390/include/asm/aef.h
+F:	arch/s390/include/asm/kvm_host_arm64*
+F:	arch/s390/include/asm/sae*
+F:	arch/s390/kernel/aef.c
+F:	arch/s390/kvm/arm64/
+F:	arch/s390/tools/*arm64*
+
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oupton@kernel.org>
@@ -14672,22 +14589,6 @@ F:	tools/testing/selftests/drivers/s390x
 F:	tools/testing/selftests/kvm/*/s390/
 F:	tools/testing/selftests/kvm/s390/
 
-KERNEL VIRTUAL MACHINE for arm-on-s390 (KVM/s390)
-R:	Steffen Eiden <seiden@linux.ibm.com>
-R:	Andreas Grapentin <gra@linux.ibm.com>
-R:	Marc Zyngier <maz@kernel.org>
-L:	kvm@vger.kernel.org
-L:	linux-s390@vger.kernel.org
-S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
-F:	arch/s390/include/arm64/
-F:	arch/s390/include/asm/aef.h
-F:	arch/s390/include/asm/kvm_host_arm64*
-F:	arch/s390/include/asm/sae*
-F:	arch/s390/kernel/aef.c
-F:	arch/s390/kvm/arm64/
-F:	arch/s390/tools/*arm64*
-
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Sean Christopherson <seanjc@google.com>
 M:	Paolo Bonzini <pbonzini@redhat.com>
@@ -15052,13 +14953,6 @@ F:	drivers/net/wan/framer/
 F:	drivers/pinctrl/pinctrl-pef2256.c
 F:	include/linux/framer/
 
-LATTEPANDA SIGMA EC HARDWARE MONITOR DRIVER
-M:	Mariano Abad <weimaraner@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/lattepanda-sigma-ec.rst
-F:	drivers/hwmon/lattepanda-sigma-ec.c
-
 LASI 53c700 driver for PARISC
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
@@ -15066,6 +14960,13 @@ S:	Maintained
 F:	Documentation/scsi/53c700.rst
 F:	drivers/scsi/53c700*
 
+LATTEPANDA SIGMA EC HARDWARE MONITOR DRIVER
+M:	Mariano Abad <weimaraner@gmail.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/hwmon/lattepanda-sigma-ec.rst
+F:	drivers/hwmon/lattepanda-sigma-ec.c
+
 LEAKING_ADDRESSES
 M:	Tycho Andersen <tycho@tycho.pizza>
 R:	Kees Cook <kees@kernel.org>
@@ -15117,12 +15018,6 @@ F:	Documentation/wmi/devices/lenovo-wmi-
 F:	Documentation/wmi/devices/lenovo-wmi-other.rst
 F:	drivers/platform/x86/lenovo/*
 
-LENOVO WMI HOTKEY UTILITIES DRIVER
-M:	Jackie Dong <xy-jackie@139.com>
-L:	platform-driver-x86@vger.kernel.org
-S:	Maintained
-F:	drivers/platform/x86/lenovo/wmi-hotkey-utilities.c
-
 LENOVO HID drivers
 M:	Derek J. Clark <derekjohn.clark@gmail.com>
 M:	Mark Pearson <mpearson-lenovo@squebb.ca>
@@ -15134,6 +15029,12 @@ F:	drivers/hid/hid-lenovo-go-s.c
 F:	drivers/hid/hid-lenovo-go.c
 F:	drivers/hid/hid-lenovo.c
 
+LENOVO WMI HOTKEY UTILITIES DRIVER
+M:	Jackie Dong <xy-jackie@139.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Maintained
+F:	drivers/platform/x86/lenovo/wmi-hotkey-utilities.c
+
 LENOVO YOGA BOOK 9 KEYBOARD DOCK DRIVER
 M:	Dave Carey <carvsdriver@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -15141,6 +15042,14 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-driver-lenovo-yb9-kbdock
 F:	drivers/platform/x86/lenovo/yb9-kbdock.c
 
+LENOVO YOGA FAN DRIVER
+M:	Sergio Melas <sergiomelas@gmail.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+W:	https://github.com/sergiomelas
+F:	Documentation/hwmon/yogafan.rst
+F:	drivers/hwmon/yogafan.c
+
 LETSKETCH HID TABLET DRIVER
 M:	Hans de Goede <hansg@kernel.org>
 L:	linux-input@vger.kernel.org
@@ -15540,14 +15449,6 @@ W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 F:	drivers/media/usb/dvb-usb-v2/lmedm04*
 
-LENOVO YOGA FAN DRIVER
-M:	Sergio Melas <sergiomelas@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-W:	https://github.com/sergiomelas
-F:	Documentation/hwmon/yogafan.rst
-F:	drivers/hwmon/yogafan.c
-
 LOADPIN SECURITY MODULE
 M:	Kees Cook <kees@kernel.org>
 S:	Supported
@@ -15625,22 +15526,6 @@ F:	arch/loongarch/
 F:	drivers/*/*loongarch*
 F:	drivers/cpufreq/loongson3_cpufreq.c
 
-LOONGSON AUDIO (ASoC) DRIVERS
-M:	Binbin Zhou <zhoubinbin@loongson.cn>
-L:	linux-sound@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/sound/loongson,ls-audio-card.yaml
-F:	Documentation/devicetree/bindings/sound/loongson,ls2k1000-i2s.yaml
-F:	sound/soc/loongson/loongson_*.c
-F:	sound/soc/loongson/loongson_*.h
-
-LOONGSON GPIO DRIVER
-M:	Yinbo Zhu <zhuyinbo@loongson.cn>
-L:	linux-gpio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/gpio/loongson,ls-gpio.yaml
-F:	drivers/gpio/gpio-loongson-64bit.c
-
 LOONGSON-2 DMA DRIVER
 M:	Binbin Zhou <zhoubinbin@loongson.cn>
 L:	dmaengine@vger.kernel.org
@@ -15650,29 +15535,6 @@ F:	Documentation/devicetree/bindings/dma
 F:	drivers/dma/loongson/loongson2-apb-cmc-dma.c
 F:	drivers/dma/loongson/loongson2-apb-dma.c
 
-LOONGSON LS2X I2C DRIVER
-M:	Binbin Zhou <zhoubinbin@loongson.cn>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/i2c/loongson,ls2x-i2c.yaml
-F:	drivers/i2c/busses/i2c-ls2x-v2.c
-F:	drivers/i2c/busses/i2c-ls2x.c
-
-LOONGSON PWM DRIVER
-M:	Binbin Zhou <zhoubinbin@loongson.cn>
-L:	linux-pwm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/pwm/loongson,ls7a-pwm.yaml
-F:	drivers/pwm/pwm-loongson.c
-
-LOONGSON SECURITY ENGINE DRIVERS
-M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
-L:	linux-crypto@vger.kernel.org
-S:	Maintained
-F:	drivers/char/tpm/tpm_loongson.c
-F:	drivers/mfd/loongson-se.c
-F:	include/linux/mfd/loongson-se.h
-
 LOONGSON-2 SOC SERIES CLOCK DRIVER
 M:	Yinbo Zhu <zhuyinbo@loongson.cn>
 L:	linux-clk@vger.kernel.org
@@ -15681,16 +15543,6 @@ F:	Documentation/devicetree/bindings/clo
 F:	drivers/clk/clk-loongson2.c
 F:	include/dt-bindings/clock/loongson,ls2k-clk.h
 
-LOONGSON SPI DRIVER
-M:	Yinbo Zhu <zhuyinbo@loongson.cn>
-L:	linux-spi@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/spi/loongson,ls2k-spi.yaml
-F:	drivers/spi/spi-loongson-core.c
-F:	drivers/spi/spi-loongson-pci.c
-F:	drivers/spi/spi-loongson-plat.c
-F:	drivers/spi/spi-loongson.h
-
 LOONGSON-2 SOC SERIES GUTS DRIVER
 M:	Yinbo Zhu <zhuyinbo@loongson.cn>
 L:	loongarch@lists.linux.dev
@@ -15705,13 +15557,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/mmc/loongson,ls2k0500-mmc.yaml
 F:	drivers/mmc/host/loongson2-mmc.c
 
-LOONGSON-2 SOC SERIES PM DRIVER
-M:	Yinbo Zhu <zhuyinbo@loongson.cn>
-L:	linux-pm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/soc/loongson/loongson,ls2k-pmc.yaml
-F:	drivers/soc/loongson/loongson2_pm.c
-
 LOONGSON-2 SOC SERIES PINCTRL DRIVER
 M:	zhanghongchen <zhanghongchen@loongson.cn>
 M:	Yinbo Zhu <zhuyinbo@loongson.cn>
@@ -15720,6 +15565,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/pinctrl/loongson,ls2k-pinctrl.yaml
 F:	drivers/pinctrl/pinctrl-loongson2.c
 
+LOONGSON-2 SOC SERIES PM DRIVER
+M:	Yinbo Zhu <zhuyinbo@loongson.cn>
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/soc/loongson/loongson,ls2k-pmc.yaml
+F:	drivers/soc/loongson/loongson2_pm.c
+
 LOONGSON-2 SOC SERIES THERMAL DRIVER
 M:	zhanghongchen <zhanghongchen@loongson.cn>
 M:	Yinbo Zhu <zhuyinbo@loongson.cn>
@@ -15735,12 +15587,69 @@ S:	Maintained
 F:	drivers/char/ipmi/ipmi_si_ls2k.c
 F:	drivers/mfd/ls2k-bmc-core.c
 
+LOONGSON AUDIO (ASoC) DRIVERS
+M:	Binbin Zhou <zhoubinbin@loongson.cn>
+L:	linux-sound@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/sound/loongson,ls-audio-card.yaml
+F:	Documentation/devicetree/bindings/sound/loongson,ls2k1000-i2s.yaml
+F:	sound/soc/loongson/loongson_*.c
+F:	sound/soc/loongson/loongson_*.h
+
 LOONGSON EDAC DRIVER
 M:	Zhao Qunqin <zhaoqunqin@loongson.cn>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	drivers/edac/loongson_edac.c
 
+LOONGSON GPIO DRIVER
+M:	Yinbo Zhu <zhuyinbo@loongson.cn>
+L:	linux-gpio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/gpio/loongson,ls-gpio.yaml
+F:	drivers/gpio/gpio-loongson-64bit.c
+
+LOONGSON LS2X I2C DRIVER
+M:	Binbin Zhou <zhoubinbin@loongson.cn>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/i2c/loongson,ls2x-i2c.yaml
+F:	drivers/i2c/busses/i2c-ls2x-v2.c
+F:	drivers/i2c/busses/i2c-ls2x.c
+
+LOONGSON PWM DRIVER
+M:	Binbin Zhou <zhoubinbin@loongson.cn>
+L:	linux-pwm@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/pwm/loongson,ls7a-pwm.yaml
+F:	drivers/pwm/pwm-loongson.c
+
+LOONGSON SECURITY ENGINE DRIVERS
+M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/char/tpm/tpm_loongson.c
+F:	drivers/mfd/loongson-se.c
+F:	include/linux/mfd/loongson-se.h
+
+LOONGSON SPI DRIVER
+M:	Yinbo Zhu <zhuyinbo@loongson.cn>
+L:	linux-spi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/spi/loongson,ls2k-spi.yaml
+F:	drivers/spi/spi-loongson-core.c
+F:	drivers/spi/spi-loongson-pci.c
+F:	drivers/spi/spi-loongson-plat.c
+F:	drivers/spi/spi-loongson.h
+
+LPC32XX DMAMUX SUPPORT
+M:	J.M.B. Downing <jonathan.downing@nautel.com>
+M:	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
+R:	Vladimir Zapolskiy <vz@mleia.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/devicetree/bindings/dma/nxp,lpc3220-dmamux.yaml
+
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 M:	Sathya Prakash <sathya.prakash@broadcom.com>
 M:	Sreekanth Reddy <sreekanth.reddy@broadcom.com>
@@ -15813,14 +15722,6 @@ F:	drivers/hwmon/ltc2947-i2c.c
 F:	drivers/hwmon/ltc2947-spi.c
 F:	drivers/hwmon/ltc2947.h
 
-LTC2991 HARDWARE MONITOR DRIVER
-M:	Antoniu Miclaus <antoniu.miclaus@analog.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Supported
-W:	https://ez.analog.com/linux-software-drivers
-F:	Documentation/devicetree/bindings/hwmon/adi,ltc2991.yaml
-F:	drivers/hwmon/ltc2991.c
-
 LTC2983 IIO TEMPERATURE DRIVER
 M:	Nuno Sá <nuno.sa@analog.com>
 L:	linux-iio@vger.kernel.org
@@ -15829,6 +15730,14 @@ W:	https://ez.analog.com/linux-software-
 F:	Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
 F:	drivers/iio/temperature/ltc2983.c
 
+LTC2991 HARDWARE MONITOR DRIVER
+M:	Antoniu Miclaus <antoniu.miclaus@analog.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Supported
+W:	https://ez.analog.com/linux-software-drivers
+F:	Documentation/devicetree/bindings/hwmon/adi,ltc2991.yaml
+F:	drivers/hwmon/ltc2991.c
+
 LTC3208 LED DRIVER
 M:	Jan Carlo Roleda <jancarlo.roleda@analog.com>
 L:	linux-leds@vger.kernel.org
@@ -15900,6 +15809,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/light/liteon,ltr390.yaml
 F:	drivers/iio/light/ltr390.c
 
+LYNX PCS MODULE
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/pcs/pcs-lynx.c
+F:	include/linux/pcs-lynx.h
+
 LYNX SERDES PHY DRIVERS
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 M:	Vladimir Oltean <vladimir.oltean@nxp.com>
@@ -15913,13 +15829,6 @@ F:	drivers/phy/freescale/phy-fsl-lynx-co
 F:	drivers/phy/freescale/phy-fsl-lynx-core.h
 F:	include/soc/fsl/phy-fsl-lynx.h
 
-LYNX PCS MODULE
-M:	Ioana Ciornei <ioana.ciornei@nxp.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/net/pcs/pcs-lynx.c
-F:	include/linux/pcs-lynx.h
-
 M68K ARCHITECTURE
 M:	Geert Uytterhoeven <geert@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org
@@ -16187,6 +16096,11 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/nand/raw/marvell_nand.c
 
+MARVELL OCTEON CN10K DPI DRIVER
+M:	Vamsi Attunuru <vattunuru@marvell.com>
+S:	Supported
+F:	drivers/misc/mrvl_cn10k_dpi.c
+
 MARVELL OCTEON ENDPOINT DRIVER
 M:	Veerasenareddy Burru <vburru@marvell.com>
 M:	Sathesh Edara <sedara@marvell.com>
@@ -16203,6 +16117,17 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/octeon_ep_vf
 
+MARVELL OCTEON ENDPOINT VIRTIO DATA PATH ACCELERATOR
+R:	schalla@marvell.com
+R:	vattunuru@marvell.com
+F:	drivers/vdpa/octeon_ep/
+
+MARVELL OCTEON HOTPLUG DRIVER
+R:	Shijith Thotton <sthotton@marvell.com>
+R:	Vamsi Attunuru <vattunuru@marvell.com>
+S:	Supported
+F:	drivers/pci/hotplug/octep_hp.c
+
 MARVELL OCTEONTX2 PHYSICAL FUNCTION DRIVER
 M:	Sunil Goutham <sgoutham@marvell.com>
 M:	Geetha sowjanya <gakula@marvell.com>
@@ -16255,22 +16180,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.yaml
 F:	drivers/mmc/host/sdhci-xenon*
 
-MARVELL OCTEON CN10K DPI DRIVER
-M:	Vamsi Attunuru <vattunuru@marvell.com>
-S:	Supported
-F:	drivers/misc/mrvl_cn10k_dpi.c
-
-MARVELL OCTEON ENDPOINT VIRTIO DATA PATH ACCELERATOR
-R:	schalla@marvell.com
-R:	vattunuru@marvell.com
-F:	drivers/vdpa/octeon_ep/
-
-MARVELL OCTEON HOTPLUG DRIVER
-R:	Shijith Thotton <sthotton@marvell.com>
-R:	Vamsi Attunuru <vattunuru@marvell.com>
-S:	Supported
-F:	drivers/pci/hotplug/octep_hp.c
-
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
@@ -16358,6 +16267,13 @@ S:	Orphan
 F:	Documentation/hwmon/max6650.rst
 F:	drivers/hwmon/max6650.c
 
+MAX77705 HARDWARE MONITORING DRIVER
+M:	Dzmitry Sankouski <dsankouski@gmail.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/hwmon/max77705.rst
+F:	drivers/hwmon/max77705-hwmon.c
+
 MAX9286 QUAD GMSL DESERIALIZER DRIVER
 M:	Jacopo Mondi <jacopo+renesas@jmondi.org>
 M:	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
@@ -16492,6 +16408,12 @@ F:	Documentation/devicetree/bindings/mfd
 F:	drivers/mfd/max77714.c
 F:	include/linux/mfd/max77714.h
 
+MAXIM MAX77759 BATTERY CHARGER DRIVER
+M:	Amit Sunil Dhamne <amitsd@google.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/power/supply/max77759_charger.c
+
 MAXIM MAX77759 PMIC MFD DRIVER
 M:	André Draszik <andre.draszik@linaro.org>
 L:	linux-kernel@vger.kernel.org
@@ -16502,12 +16424,6 @@ F:	drivers/mfd/max77759.c
 F:	drivers/nvmem/max77759-nvmem.c
 F:	include/linux/mfd/max77759.h
 
-MAXIM MAX77759 BATTERY CHARGER DRIVER
-M:	Amit Sunil Dhamne <amitsd@google.com>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-F:	drivers/power/supply/max77759_charger.c
-
 MAXIM MAX77802 PMIC REGULATOR DEVICE DRIVER
 M:	Javier Martinez Canillas <javier@dowhile0.org>
 L:	linux-kernel@vger.kernel.org
@@ -17370,23 +17286,6 @@ F:	arch/*/include/asm/sync_core.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
-MEMORY MANAGEMENT - MEMBLOCK AND INITIALIZATION
-M:	Mike Rapoport <rppt@kernel.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git fixes
-F:	Documentation/core-api/boot-time-mm.rst
-F:	include/linux/kho/abi/memblock.h
-F:	include/linux/memblock.h
-F:	mm/arch_numa.c
-F:	mm/memblock.c
-F:	mm/memtest.c
-F:	mm/mm_init.c
-F:	mm/mm_init.h
-F:	mm/rodata_test.c
-F:	tools/testing/memblock/
-
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-kernel@vger.kernel.org
@@ -17496,6 +17395,25 @@ F:	mm/vmstat.c
 F:	scripts/gdb/linux/mm.py
 N:	include\/linux\/page[-_][a-zA-Z]*
 
+MEMORY MANAGEMENT - DAMON
+M:	SJ Park <sj@kernel.org>
+L:	damon@lists.linux.dev
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	https://damonitor.github.io
+P:	Documentation/mm/damon/maintainer-profile.rst
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
+F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
+F:	Documentation/admin-guide/mm/damon/
+F:	Documentation/mm/damon/
+F:	include/linux/damon.h
+F:	include/trace/events/damon.h
+F:	mm/damon/
+F:	samples/damon/
+F:	tools/testing/selftests/damon/
+
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
@@ -17520,6 +17438,55 @@ F:	tools/mm/gup_bench.c
 F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
+MEMORY MANAGEMENT - HMM (Heterogeneous Memory Management)
+M:	Jason Gunthorpe <jgg@nvidia.com>
+M:	Leon Romanovsky <leonro@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/mm/hmm.rst
+F:	include/linux/hmm*
+F:	lib/test_hmm*
+F:	mm/hmm*
+F:	tools/testing/selftests/mm/*hmm*
+
+MEMORY MANAGEMENT - HUGETLB
+M:	Muchun Song <muchun.song@linux.dev>
+M:	Oscar Salvador <osalvador@suse.de>
+R:	David Hildenbrand <david@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
+F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
+F:	Documentation/admin-guide/mm/hugetlbpage.rst
+F:	Documentation/mm/hugetlbfs_reserv.rst
+F:	Documentation/mm/vmemmap_dedup.rst
+F:	fs/hugetlbfs/
+F:	include/linux/hugetlb*
+F:	include/linux/vmemmap-optimization.h
+F:	include/trace/events/hugetlbfs.h
+F:	mm/hugetlb.c
+F:	mm/hugetlb_cgroup.c
+F:	mm/hugetlb_cma.c
+F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_internal.h
+F:	mm/hugetlb_sysctl.c
+F:	mm/hugetlb_sysfs.c
+F:	mm/hugetlb_vmemmap.c
+F:	mm/hugetlb_vmemmap.h
+F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+
+MEMORY MANAGEMENT - HWPOISON MEMORY FAILURE HANDLING
+M:	Miaohe Lin <linmiaohe@huawei.com>
+R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-memory-page-offline
+F:	include/linux/memory-failure.h
+F:	include/trace/events/memory-failure.h
+F:	mm/hwpoison-inject.c
+F:	mm/memory-failure.c
+F:	tools/testing/selftests/mm/memory-failure.c
+
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin@linux.dev>
@@ -17535,6 +17502,23 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
+MEMORY MANAGEMENT - MEMBLOCK AND INITIALIZATION
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git fixes
+F:	Documentation/core-api/boot-time-mm.rst
+F:	include/linux/kho/abi/memblock.h
+F:	include/linux/memblock.h
+F:	mm/arch_numa.c
+F:	mm/memblock.c
+F:	mm/memtest.c
+F:	mm/mm_init.c
+F:	mm/mm_init.h
+F:	mm/rodata_test.c
+F:	tools/testing/memblock/
+
 MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
@@ -17567,6 +17551,96 @@ F:	mm/sparse.c
 F:	mm/sparse.h
 K:	(?i:vmemmap)
 
+MEMORY MANAGEMENT - MEMORY MAPPING
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Liam R. Howlett <liam@infradead.org>
+M:	Lorenzo Stoakes <ljs@kernel.org>
+R:	Vlastimil Babka <vbabka@kernel.org>
+R:	Jann Horn <jannh@google.com>
+R:	Pedro Falcato <pfalcato@suse.de>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/protection-keys.rst
+F:	Documentation/filesystems/mmap_prepare.rst
+F:	Documentation/userspace-api/mseal.rst
+F:	fs/proc/task_mmu.c
+F:	fs/proc/task_nommu.c
+F:	include/linux/mman.h
+F:	include/linux/pkeys.h
+F:	include/trace/events/mmap.h
+F:	include/uapi/linux/mman.h
+F:	mm/char-mem.c
+F:	mm/mincore.c
+F:	mm/mlock.c
+F:	mm/mmap.c
+F:	mm/mprotect.c
+F:	mm/mremap.c
+F:	mm/mseal.c
+F:	mm/msync.c
+F:	mm/nommu.c
+F:	mm/vma.c
+F:	mm/vma.h
+F:	mm/vma_exec.c
+F:	mm/vma_init.c
+F:	mm/vma_internal.h
+F:	tools/testing/selftests/mm/merge.c
+F:	tools/testing/vma/
+
+MEMORY MANAGEMENT - MEMORY MAPPING - LOCKING
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Liam R. Howlett <liam@infradead.org>
+M:	Lorenzo Stoakes <ljs@kernel.org>
+R:	Vlastimil Babka <vbabka@kernel.org>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/mm/process_addrs.rst
+F:	include/linux/mmap_lock.h
+F:	include/trace/events/mmap_lock.h
+F:	mm/mmap_lock.c
+
+MEMORY MANAGEMENT - MEMORY MAPPING - MADVISE (MEMORY ADVICE)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Liam R. Howlett <liam@infradead.org>
+M:	Lorenzo Stoakes <ljs@kernel.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Vlastimil Babka <vbabka@kernel.org>
+R:	Jann Horn <jannh@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/uapi/asm-generic/mman-common.h
+F:	mm/madvise.c
+
+MEMORY MANAGEMENT - MEMORY RESOURCE CONTROLLER (MEMCG)
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Michal Hocko <mhocko@kernel.org>
+M:	Roman Gushchin <roman.gushchin@linux.dev>
+M:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Muchun Song <muchun.song@linux.dev>
+L:	cgroups@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/cgroup-v1/memory.rst
+F:	include/linux/memcontrol.h
+F:	include/linux/page_counter.h
+F:	include/trace/events/memcg.h
+F:	mm/memcontrol-v1.c
+F:	mm/memcontrol-v1.h
+F:	mm/memcontrol.c
+F:	mm/page_counter.c
+F:	samples/cgroup/*
+F:	tools/testing/selftests/cgroup/memcg_protection.m
+F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+F:	tools/testing/selftests/cgroup/test_kmem.c
+F:	tools/testing/selftests/cgroup/test_memcontrol.c
+
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>
@@ -17659,6 +17733,21 @@ X:	Documentation/ABI/testing/sysfs-kerne
 X:	Documentation/admin-guide/mm/damon/
 X:	Documentation/mm/damon/
 
+MEMORY MANAGEMENT - MMU GATHER AND TLB INVALIDATION
+M:	Will Deacon <will@kernel.org>
+M:	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Nick Piggin <npiggin@gmail.com>
+M:	Peter Zijlstra <peterz@infradead.org>
+L:	linux-arch@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/core-api/cachetlb.rst
+F:	arch/*/include/asm/tlb.h
+F:	include/asm-generic/tlb.h
+F:	include/trace/events/tlb.h
+F:	mm/mmu_gather.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
@@ -17739,6 +17828,48 @@ F:	scripts/gdb/linux/page_owner.py
 F:	tools/mm/page_owner_filter.c
 F:	tools/mm/page_owner_sort.c
 
+MEMORY MANAGEMENT - PAGE CACHE
+M:	Matthew Wilcox (Oracle) <willy@infradead.org>
+M:	Jan Kara <jack@suse.cz>
+L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Supported
+T:	git git://git.infradead.org/users/willy/pagecache.git
+F:	Documentation/filesystems/locking.rst
+F:	Documentation/filesystems/vfs.rst
+F:	include/linux/pagemap.h
+F:	include/linux/writeback.h
+F:	include/trace/events/filemap.h
+F:	include/trace/events/readahead.h
+F:	include/trace/events/writeback.h
+F:	mm/filemap.c
+F:	mm/page-writeback.c
+F:	mm/readahead.c
+F:	mm/truncate.c
+
+MEMORY MANAGEMENT - PAGE TABLE CHECK
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/mm/page_table_check.rst
+F:	include/linux/page_table_check.h
+F:	mm/page_table_check.c
+
+MEMORY MANAGEMENT - PER-CPU MEMORY ALLOCATOR
+M:	Dennis Zhou <dennis@kernel.org>
+M:	Tejun Heo <tj@kernel.org>
+M:	Christoph Lameter <cl@gentwo.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
+F:	arch/*/include/asm/percpu.h
+F:	include/linux/percpu*.h
+F:	include/trace/events/percpu.h
+F:	lib/percpu*.c
+F:	mm/percpu*.c
+F:	mm/percpu-internal.h
+
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
@@ -17771,6 +17902,21 @@ F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
 F:	tools/testing/selftests/mm/rmap.c
 
+MEMORY MANAGEMENT - RUST
+M:	Alice Ryhl <aliceryhl@google.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
+R:	Liam R. Howlett <liam@infradead.org>
+L:	linux-mm@kvack.org
+L:	rust-for-linux@vger.kernel.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	rust/helpers/mm.c
+F:	rust/helpers/page.c
+F:	rust/kernel/mm.rs
+F:	rust/kernel/mm/
+F:	rust/kernel/page.rs
+
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
@@ -17798,6 +17944,52 @@ F:	mm/shmem_quota.c
 F:	tools/testing/selftests/memfd/
 F:	tools/testing/selftests/tmpfs/
 
+MEMORY MANAGEMENT - SHRINKER
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Dave Chinner <david@fromorbit.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
+R:	Muchun Song <muchun.song@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
+F:	include/linux/list_lru.h
+F:	include/linux/shrinker.h
+F:	mm/list_lru.c
+F:	mm/shrinker.c
+F:	mm/shrinker_debug.c
+F:	tools/cgroup/memcg_shrinker.py
+
+MEMORY MANAGEMENT - SLAB ALLOCATOR
+M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry@kernel.org>
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Hao Li <hao.li@linux.dev>
+R:	Christoph Lameter <cl@gentwo.org>
+R:	David Rientjes <rientjes@google.com>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
+F:	Documentation/ABI/testing/sysfs-kernel-slab
+F:	Documentation/admin-guide/mm/slab.rst
+F:	Documentation/mm/slab.rst
+F:	include/linux/mempool.h
+F:	include/linux/slab.h
+F:	include/trace/events/kmem.h
+F:	lib/tests/slub_kunit.c
+F:	mm/failslab.c
+F:	mm/mempool.c
+F:	mm/slab.h
+F:	mm/slab_common.c
+F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
+
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Chris Li <chrisl@kernel.org>
@@ -17864,87 +18056,41 @@ F:	include/uapi/linux/userfaultfd.h
 F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
 
-MEMORY MANAGEMENT - RUST
-M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <liam@infradead.org>
-L:	linux-mm@kvack.org
-L:	rust-for-linux@vger.kernel.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	rust/helpers/mm.c
-F:	rust/helpers/page.c
-F:	rust/kernel/mm.rs
-F:	rust/kernel/mm/
-F:	rust/kernel/page.rs
-
-MEMORY MANAGEMENT - MEMORY MAPPING
+MEMORY MANAGEMENT - VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
-R:	Pedro Falcato <pfalcato@suse.de>
+M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/core-api/protection-keys.rst
-F:	Documentation/filesystems/mmap_prepare.rst
-F:	Documentation/userspace-api/mseal.rst
-F:	fs/proc/task_mmu.c
-F:	fs/proc/task_nommu.c
-F:	include/linux/mman.h
-F:	include/linux/pkeys.h
-F:	include/trace/events/mmap.h
-F:	include/uapi/linux/mman.h
-F:	mm/char-mem.c
-F:	mm/mincore.c
-F:	mm/mlock.c
-F:	mm/mmap.c
-F:	mm/mprotect.c
-F:	mm/mremap.c
-F:	mm/mseal.c
-F:	mm/msync.c
-F:	mm/nommu.c
-F:	mm/vma.c
-F:	mm/vma.h
-F:	mm/vma_exec.c
-F:	mm/vma_init.c
-F:	mm/vma_internal.h
-F:	tools/testing/selftests/mm/merge.c
-F:	tools/testing/vma/
+F:	include/linux/vmalloc.h
+F:	include/trace/events/vmalloc.h
+F:	lib/test_vmalloc.c
+F:	mm/vmalloc.c
+F:	mm/vmalloc.h
+F:	scripts/gdb/linux/vmalloc.py
 
-MEMORY MANAGEMENT - MEMORY MAPPING - LOCKING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Shakeel Butt <shakeel.butt@linux.dev>
+MEMORY MANAGEMENT - ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+M:	Minchan Kim <minchan@kernel.org>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/mm/process_addrs.rst
-F:	include/linux/mmap_lock.h
-F:	include/trace/events/mmap_lock.h
-F:	mm/mmap_lock.c
+F:	Documentation/mm/zsmalloc.rst
+F:	include/linux/zsmalloc.h
+F:	mm/zpdesc.h
+F:	mm/zsmalloc.c
 
-MEMORY MANAGEMENT - MEMORY MAPPING - MADVISE (MEMORY ADVICE)
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
+MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Yosry Ahmed <yosry@kernel.org>
+M:	Nhat Pham <nphamcs@gmail.com>
+R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	include/uapi/asm-generic/mman-common.h
-F:	mm/madvise.c
+F:	Documentation/admin-guide/mm/zswap.rst
+F:	include/linux/zswap.h
+F:	mm/zswap.c
+F:	tools/testing/selftests/cgroup/test_zswap.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
@@ -18499,20 +18645,6 @@ F:	Documentation/driver-api/surface_aggr
 F:	drivers/platform/surface/surface_dtx.c
 F:	include/uapi/linux/surface_aggregator/dtx.h
 
-MICROSOFT SURFACE SENSOR FAN DRIVER
-M:	Maximilian Luz <luzmaximilian@gmail.com>
-M:	Ivor Wanders <ivor@iwanders.net>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/surface_fan.rst
-F:	drivers/hwmon/surface_fan.c
-
-MICROSOFT SURFACE SENSOR THERMAL DRIVER
-M:	Maximilian Luz <luzmaximilian@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	drivers/hwmon/surface_temp.c
-
 MICROSOFT SURFACE GPE LID SUPPORT DRIVER
 M:	Maximilian Luz <luzmaximilian@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -18553,6 +18685,20 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/surface/surfacepro3_button.c
 
+MICROSOFT SURFACE SENSOR FAN DRIVER
+M:	Maximilian Luz <luzmaximilian@gmail.com>
+M:	Ivor Wanders <ivor@iwanders.net>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/hwmon/surface_fan.rst
+F:	drivers/hwmon/surface_fan.c
+
+MICROSOFT SURFACE SENSOR THERMAL DRIVER
+M:	Maximilian Luz <luzmaximilian@gmail.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	drivers/hwmon/surface_temp.c
+
 MICROSOFT SURFACE SYSTEM AGGREGATOR HUB DRIVER
 M:	Maximilian Luz <luzmaximilian@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -18728,21 +18874,6 @@ S:	Maintained
 F:	drivers/phy/marvell/phy-mmp3-usb.c
 F:	drivers/phy/marvell/phy-pxa-usb.c
 
-MEMORY MANAGEMENT - MMU GATHER AND TLB INVALIDATION
-M:	Will Deacon <will@kernel.org>
-M:	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Nick Piggin <npiggin@gmail.com>
-M:	Peter Zijlstra <peterz@infradead.org>
-L:	linux-arch@vger.kernel.org
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/core-api/cachetlb.rst
-F:	arch/*/include/asm/tlb.h
-F:	include/asm-generic/tlb.h
-F:	include/trace/events/tlb.h
-F:	mm/mmu_gather.c
-
 MN88472 MEDIA DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
@@ -18972,12 +19103,6 @@ S:	Odd Fixes
 F:	Documentation/devicetree/bindings/net/ieee802154/mrf24j40.txt
 F:	drivers/net/ieee802154/mrf24j40.c
 
-MSI HID DRIVER
-M:	Derek J. Clark <derekjohn.clark@gmail.com>
-L:	linux-input@vger.kernel.org
-S:	Maintained
-F:	drivers/hid/hid-msi.c
-
 MSI EC DRIVER
 M:	Nikita Kravets <teackot@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
@@ -18985,17 +19110,18 @@ S:	Maintained
 W:	https://github.com/BeardOverflow/msi-ec
 F:	drivers/platform/x86/msi-ec.*
 
+MSI HID DRIVER
+M:	Derek J. Clark <derekjohn.clark@gmail.com>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/hid/hid-msi.c
+
 MSI LAPTOP SUPPORT
 M:	"Lee, Chun-Yi" <jlee@suse.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
 
-MSI WMI SUPPORT
-L:	platform-driver-x86@vger.kernel.org
-S:	Orphan
-F:	drivers/platform/x86/msi-wmi.c
-
 MSI WMI PLATFORM FEATURES
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
@@ -19004,6 +19130,11 @@ F:	Documentation/ABI/testing/debugfs-msi
 F:	Documentation/wmi/devices/msi-wmi-platform.rst
 F:	drivers/platform/x86/msi-wmi-platform.c
 
+MSI WMI SUPPORT
+L:	platform-driver-x86@vger.kernel.org
+S:	Orphan
+F:	drivers/platform/x86/msi-wmi.c
+
 MSI001 MEDIA DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
@@ -19164,6 +19295,15 @@ S:	Orphan
 W:	https://www.cspi.com/ethernet-products/support/downloads/
 F:	drivers/net/ethernet/myricom/myri10ge/
 
+NAMESPACES:
+M:	Christian Brauner <christian@brauner.io>
+R:	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	rust/kernel/pid_namespace.rs
+F:	kernel/pid_namespace.c
+F:	tools/testing/selftests/pid_namespace/
+
 NAND FLASH SUBSYSTEM
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 R:	Richard Weinberger <richard@nod.at>
@@ -19176,15 +19316,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	drivers/mtd/nand/
 F:	include/linux/mtd/*nand*.h
 
-NAMESPACES:
-M:	Christian Brauner <christian@brauner.io>
-R:	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-F:	rust/kernel/pid_namespace.rs
-F:	kernel/pid_namespace.c
-F:	tools/testing/selftests/pid_namespace/
-
 NATIONAL INSTRUMENTS SERIAL DRIVER
 M:	Chaitanya Vadrevu <chaitanya.vadrevu@emerson.com>
 L:	linux-serial@vger.kernel.org
@@ -19247,6 +19378,14 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/nebula-matrix/
 F:	drivers/net/ethernet/nebula-matrix/
 
+NET_FAILOVER MODULE
+M:	Sridhar Samudrala <sridhar.samudrala@intel.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/networking/net_failover.rst
+F:	drivers/net/net_failover.c
+F:	include/net/net_failover.h
+
 NETCONSOLE
 M:	Breno Leitao <leitao@debian.org>
 R:	Gustavo Luiz Duarte <gustavold@gmail.com>
@@ -19327,73 +19466,6 @@ W:	https://fedorahosted.org/dropwatch/
 F:	include/uapi/linux/net_dropmon.h
 F:	net/core/drop_monitor.c
 
-NETWORKING DRIVERS
-M:	Andrew Lunn <andrew+netdev@lunn.ch>
-M:	"David S. Miller" <davem@davemloft.net>
-M:	Eric Dumazet <edumazet@kernel.org>
-M:	Jakub Kicinski <kuba@kernel.org>
-M:	Paolo Abeni <pabeni@redhat.com>
-L:	netdev@vger.kernel.org
-S:	Maintained
-P:	Documentation/process/maintainer-netdev.rst
-Q:	https://patchwork.kernel.org/project/netdevbpf/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
-F:	Documentation/devicetree/bindings/net/
-F:	Documentation/networking/net_cachelines/net_device.rst
-F:	drivers/connector/
-F:	drivers/net/
-F:	drivers/ptp/
-F:	drivers/s390/net/
-F:	include/dt-bindings/net/
-F:	include/linux/cn_proc.h
-F:	include/linux/etherdevice.h
-F:	include/linux/ethtool_netlink.h
-F:	include/linux/fcdevice.h
-F:	include/linux/fddidevice.h
-F:	include/linux/if_*
-F:	include/linux/inetdevice.h
-F:	include/linux/netdev*
-F:	include/uapi/linux/cn_proc.h
-F:	include/uapi/linux/ethtool_netlink*
-F:	include/uapi/linux/if_*
-F:	include/uapi/linux/net_shaper.h
-F:	include/uapi/linux/netdev*
-F:	tools/testing/selftests/drivers/net/
-X:	Documentation/devicetree/bindings/net/bluetooth/
-X:	Documentation/devicetree/bindings/net/can/
-X:	Documentation/devicetree/bindings/net/wireless/
-X:	drivers/net/can/
-X:	drivers/net/wireless/
-
-NETWORKING DRIVERS (WIRELESS)
-M:	Johannes Berg <johannes@sipsolutions.net>
-L:	linux-wireless@vger.kernel.org
-S:	Maintained
-W:	https://wireless.docs.kernel.org/en/latest/
-Q:	https://patchwork.kernel.org/project/linux-wireless/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
-F:	Documentation/devicetree/bindings/net/wireless/
-F:	drivers/net/wireless/
-X:	drivers/net/wireless/ath/
-X:	drivers/net/wireless/broadcom/
-X:	drivers/net/wireless/intel/
-X:	drivers/net/wireless/intersil/
-X:	drivers/net/wireless/marvell/
-X:	drivers/net/wireless/mediatek/mt76/
-X:	drivers/net/wireless/mediatek/mt7601u/
-X:	drivers/net/wireless/microchip/
-X:	drivers/net/wireless/purelifi/
-X:	drivers/net/wireless/quantenna/
-X:	drivers/net/wireless/ralink/
-X:	drivers/net/wireless/realtek/
-X:	drivers/net/wireless/rsi/
-X:	drivers/net/wireless/silabs/
-X:	drivers/net/wireless/st/
-X:	drivers/net/wireless/ti/
-X:	drivers/net/wireless/zydas/
-
 NETWORKING [DSA]
 M:	Andrew Lunn <andrew@lunn.ch>
 M:	Vladimir Oltean <olteanv@gmail.com>
@@ -19408,16 +19480,6 @@ F:	include/net/dsa.h
 F:	net/dsa/
 F:	tools/testing/selftests/drivers/net/dsa/
 
-NETWORKING [ETHTOOL]
-M:	Andrew Lunn <andrew@lunn.ch>
-M:	Jakub Kicinski <kuba@kernel.org>
-F:	Documentation/netlink/specs/ethtool.yaml
-F:	Documentation/networking/ethtool-netlink.rst
-F:	include/linux/ethtool*
-F:	include/uapi/linux/ethtool*
-F:	net/ethtool/
-F:	tools/testing/selftests/drivers/net/*/ethtool*
-
 NETWORKING [ETHTOOL CABLE TEST]
 M:	Andrew Lunn <andrew@lunn.ch>
 F:	net/ethtool/cabletest.c
@@ -19430,13 +19492,6 @@ F:	net/ethtool/mm.c
 F:	tools/testing/selftests/drivers/net/hw/ethtool_mm.sh
 K:	ethtool_mm
 
-NETWORKING [ETHTOOL PHY TOPOLOGY]
-M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
-F:	Documentation/networking/phy-link-topology.rst
-F:	drivers/net/phy/phy_link_topology.c
-F:	include/linux/phy_link_topology.h
-F:	net/ethtool/phy.c
-
 NETWORKING [ETHTOOL PHY PORT]
 M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
 F:	Documentation/devicetree/bindings/net/ethernet-connector.yaml
@@ -19446,6 +19501,23 @@ F:	include/linux/phy_port.h
 F:	net/ethtool/port.c
 K:	struct\s+phy_port|phy_port_
 
+NETWORKING [ETHTOOL PHY TOPOLOGY]
+M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
+F:	Documentation/networking/phy-link-topology.rst
+F:	drivers/net/phy/phy_link_topology.c
+F:	include/linux/phy_link_topology.h
+F:	net/ethtool/phy.c
+
+NETWORKING [ETHTOOL]
+M:	Andrew Lunn <andrew@lunn.ch>
+M:	Jakub Kicinski <kuba@kernel.org>
+F:	Documentation/netlink/specs/ethtool.yaml
+F:	Documentation/networking/ethtool-netlink.rst
+F:	include/linux/ethtool*
+F:	include/uapi/linux/ethtool*
+F:	net/ethtool/
+F:	tools/testing/selftests/drivers/net/*/ethtool*
+
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Eric Dumazet <edumazet@kernel.org>
@@ -19663,6 +19735,22 @@ F:	net/mptcp/
 F:	tools/testing/selftests/bpf/*/*mptcp*.[ch]
 F:	tools/testing/selftests/net/mptcp/
 
+NETWORKING [SOCKETS]
+M:	Eric Dumazet <edumazet@kernel.org>
+M:	Kuniyuki Iwashima <kuniyu@google.com>
+M:	Paolo Abeni <pabeni@redhat.com>
+M:	Willem de Bruijn <willemb@google.com>
+S:	Maintained
+F:	include/linux/sock_diag.h
+F:	include/linux/socket.h
+F:	include/linux/sockptr.h
+F:	include/net/sock.h
+F:	include/net/sock_reuseport.h
+F:	include/uapi/linux/socket.h
+F:	net/core/*sock*
+F:	net/core/scm.c
+F:	net/socket.c
+
 NETWORKING [SRv6]
 M:	Andrea Mayer <andrea.mayer@uniroma2.it>
 L:	netdev@vger.kernel.org
@@ -19707,22 +19795,6 @@ F:	include/uapi/linux/tls.h
 F:	net/tls/
 F:	tools/testing/selftests/net/tls.c
 
-NETWORKING [SOCKETS]
-M:	Eric Dumazet <edumazet@kernel.org>
-M:	Kuniyuki Iwashima <kuniyu@google.com>
-M:	Paolo Abeni <pabeni@redhat.com>
-M:	Willem de Bruijn <willemb@google.com>
-S:	Maintained
-F:	include/linux/sock_diag.h
-F:	include/linux/socket.h
-F:	include/linux/sockptr.h
-F:	include/net/sock.h
-F:	include/net/sock_reuseport.h
-F:	include/uapi/linux/socket.h
-F:	net/core/*sock*
-F:	net/core/scm.c
-F:	net/socket.c
-
 NETWORKING [UNIX SOCKETS]
 M:	Kuniyuki Iwashima <kuniyu@google.com>
 S:	Maintained
@@ -19732,6 +19804,73 @@ F:	include/uapi/linux/unix_diag.h
 F:	net/unix/
 F:	tools/testing/selftests/net/af_unix/
 
+NETWORKING DRIVERS
+M:	Andrew Lunn <andrew+netdev@lunn.ch>
+M:	"David S. Miller" <davem@davemloft.net>
+M:	Eric Dumazet <edumazet@kernel.org>
+M:	Jakub Kicinski <kuba@kernel.org>
+M:	Paolo Abeni <pabeni@redhat.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+P:	Documentation/process/maintainer-netdev.rst
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+F:	Documentation/devicetree/bindings/net/
+F:	Documentation/networking/net_cachelines/net_device.rst
+F:	drivers/connector/
+F:	drivers/net/
+F:	drivers/ptp/
+F:	drivers/s390/net/
+F:	include/dt-bindings/net/
+F:	include/linux/cn_proc.h
+F:	include/linux/etherdevice.h
+F:	include/linux/ethtool_netlink.h
+F:	include/linux/fcdevice.h
+F:	include/linux/fddidevice.h
+F:	include/linux/if_*
+F:	include/linux/inetdevice.h
+F:	include/linux/netdev*
+F:	include/uapi/linux/cn_proc.h
+F:	include/uapi/linux/ethtool_netlink*
+F:	include/uapi/linux/if_*
+F:	include/uapi/linux/net_shaper.h
+F:	include/uapi/linux/netdev*
+F:	tools/testing/selftests/drivers/net/
+X:	Documentation/devicetree/bindings/net/bluetooth/
+X:	Documentation/devicetree/bindings/net/can/
+X:	Documentation/devicetree/bindings/net/wireless/
+X:	drivers/net/can/
+X:	drivers/net/wireless/
+
+NETWORKING DRIVERS (WIRELESS)
+M:	Johannes Berg <johannes@sipsolutions.net>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+W:	https://wireless.docs.kernel.org/en/latest/
+Q:	https://patchwork.kernel.org/project/linux-wireless/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
+F:	Documentation/devicetree/bindings/net/wireless/
+F:	drivers/net/wireless/
+X:	drivers/net/wireless/ath/
+X:	drivers/net/wireless/broadcom/
+X:	drivers/net/wireless/intel/
+X:	drivers/net/wireless/intersil/
+X:	drivers/net/wireless/marvell/
+X:	drivers/net/wireless/mediatek/mt76/
+X:	drivers/net/wireless/mediatek/mt7601u/
+X:	drivers/net/wireless/microchip/
+X:	drivers/net/wireless/purelifi/
+X:	drivers/net/wireless/quantenna/
+X:	drivers/net/wireless/ralink/
+X:	drivers/net/wireless/realtek/
+X:	drivers/net/wireless/rsi/
+X:	drivers/net/wireless/silabs/
+X:	drivers/net/wireless/st/
+X:	drivers/net/wireless/ti/
+X:	drivers/net/wireless/zydas/
+
 NETXEN (1/10) GbE SUPPORT
 M:	Manish Chopra <manishc@marvell.com>
 M:	Rahul Verma <rahulv@marvell.com>
@@ -19740,14 +19879,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/qlogic/netxen/
 
-NET_FAILOVER MODULE
-M:	Sridhar Samudrala <sridhar.samudrala@intel.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	Documentation/networking/net_failover.rst
-F:	drivers/net/net_failover.c
-F:	include/net/net_failover.h
-
 NFC SUBSYSTEM
 M:	David Heidelberg <david@ixit.cz>
 L:	oe-linux-nfc@lists.linux.dev
@@ -20201,6 +20332,11 @@ F:	Documentation/devicetree/bindings/clo
 F:	drivers/clk/imx/
 F:	include/dt-bindings/clock/*imx*
 
+NXP-NCI NFC DRIVER
+S:	Orphan
+F:	Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
+F:	drivers/nfc/nxp-nci
+
 NXP NETC ETHERNET SWITCH DRIVER
 M:	Wei Fang <wei.fang@nxp.com>
 R:	Clark Wang <xiaoning.wang@nxp.com>
@@ -20228,12 +20364,6 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/nxp/
 
-NXP PF5300/PF5301/PF5302 PMIC REGULATOR DEVICE DRIVER
-M:	Woodrow Douglass <wdouglass@carnegierobotics.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/regulator/nxp,pf5300.yaml
-F:	drivers/regulator/pf530x-regulator.c
-
 NXP PF1550 PMIC MFD DRIVER
 M:	Samuel Kayode <samkay014@gmail.com>
 L:	imx@lists.linux.dev
@@ -20245,6 +20375,12 @@ F:	drivers/power/supply/pf1550-charger.c
 F:	drivers/regulator/pf1550-regulator.c
 F:	include/linux/mfd/pf1550.h
 
+NXP PF5300/PF5301/PF5302 PMIC REGULATOR DEVICE DRIVER
+M:	Woodrow Douglass <wdouglass@carnegierobotics.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/regulator/nxp,pf5300.yaml
+F:	drivers/regulator/pf530x-regulator.c
+
 NXP PF8100/PF8121A/PF8200 PMIC REGULATOR DEVICE DRIVER
 M:	Jagan Teki <jagan@amarulasolutions.com>
 S:	Maintained
@@ -20297,11 +20433,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/spi/nxp,imx94-xspi.yaml
 F:	drivers/spi/spi-nxp-xspi.c
 
-NXP-NCI NFC DRIVER
-S:	Orphan
-F:	Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
-F:	drivers/nfc/nxp-nci
-
 NXP/Goodix TFA989X (TFA1) DRIVER
 M:	Stephan Gerhold <stephan@gerhold.net>
 L:	linux-sound@vger.kernel.org
@@ -21113,25 +21244,6 @@ F:	Documentation/core-api/padata.rst
 F:	include/linux/padata.h
 F:	kernel/padata.c
 
-MEMORY MANAGEMENT - PAGE CACHE
-M:	Matthew Wilcox (Oracle) <willy@infradead.org>
-M:	Jan Kara <jack@suse.cz>
-L:	linux-fsdevel@vger.kernel.org
-L:	linux-mm@kvack.org
-S:	Supported
-T:	git git://git.infradead.org/users/willy/pagecache.git
-F:	Documentation/filesystems/locking.rst
-F:	Documentation/filesystems/vfs.rst
-F:	include/linux/pagemap.h
-F:	include/linux/writeback.h
-F:	include/trace/events/filemap.h
-F:	include/trace/events/readahead.h
-F:	include/trace/events/writeback.h
-F:	mm/filemap.c
-F:	mm/page-writeback.c
-F:	mm/readahead.c
-F:	mm/truncate.c
-
 PAGE POOL
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
@@ -21142,15 +21254,6 @@ F:	include/net/page_pool/
 F:	include/trace/events/page_pool.h
 F:	net/core/page_pool.c
 
-MEMORY MANAGEMENT - PAGE TABLE CHECK
-M:	Pasha Tatashin <pasha.tatashin@soleen.com>
-M:	Andrew Morton <akpm@linux-foundation.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/mm/page_table_check.rst
-F:	include/linux/page_table_check.h
-F:	mm/page_table_check.c
-
 PAGE STATE DEBUG SCRIPT
 M:	Ye Liu <liuye@kylinos.cn>
 S:	Maintained
@@ -21256,13 +21359,6 @@ S:	Maintained
 F:	Documentation/hwmon/pc87427.rst
 F:	drivers/hwmon/pc87427.c
 
-MAX77705 HARDWARE MONITORING DRIVER
-M:	Dzmitry Sankouski <dsankouski@gmail.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/hwmon/max77705.rst
-F:	drivers/hwmon/max77705-hwmon.c
-
 PCA9532 LED DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
 S:	Maintained
@@ -21777,6 +21873,14 @@ F:	Documentation/devicetree/bindings/pci
 F:	drivers/pci/controller/dwc/pcie-qcom-common.c
 F:	drivers/pci/controller/dwc/pcie-qcom-ep.c
 
+PCIE M.2 POWER SEQUENCING
+M:	Manivannan Sadhasivam <mani@kernel.org>
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/connector/pcie-m2-e-connector.yaml
+F:	Documentation/devicetree/bindings/connector/pcie-m2-m-connector.yaml
+F:	drivers/power/sequencing/pwrseq-pcie-m2.c
+
 PCMCIA SUBSYSTEM
 M:	Dominik Brodowski <linux@dominikbrodowski.net>
 S:	Odd Fixes
@@ -21829,20 +21933,6 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
 F:	drivers/net/ethernet/pensando/
 
-MEMORY MANAGEMENT - PER-CPU MEMORY ALLOCATOR
-M:	Dennis Zhou <dennis@kernel.org>
-M:	Tejun Heo <tj@kernel.org>
-M:	Christoph Lameter <cl@gentwo.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
-F:	arch/*/include/asm/percpu.h
-F:	include/linux/percpu*.h
-F:	include/trace/events/percpu.h
-F:	lib/percpu*.c
-F:	mm/percpu*.c
-F:	mm/percpu-internal.h
-
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <bsingharora@gmail.com>
 M:	Yang Yang <yang.yang29@zte.com.cn>
@@ -21850,16 +21940,6 @@ S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
-TASK DELAY MONITORING TOOLS
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Wang Yaxin <wang.yaxin@zte.com.cn>
-M:	Fan Yu <fan.yu9@zte.com.cn>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-F:	Documentation/accounting/delay-accounting.rst
-F:	tools/accounting/delaytop.c
-F:	tools/accounting/getdelays.c
-
 PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
@@ -22237,14 +22317,6 @@ F:	Documentation/driver-api/pwrseq.rst
 F:	drivers/power/sequencing/
 F:	include/linux/pwrseq/
 
-PCIE M.2 POWER SEQUENCING
-M:	Manivannan Sadhasivam <mani@kernel.org>
-L:	linux-pci@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/connector/pcie-m2-e-connector.yaml
-F:	Documentation/devicetree/bindings/connector/pcie-m2-m-connector.yaml
-F:	drivers/power/sequencing/pwrseq-pcie-m2.c
-
 POWER STATE COORDINATION INTERFACE (PSCI)
 M:	Mark Rutland <mark.rutland@arm.com>
 M:	Lorenzo Pieralisi <lpieralisi@kernel.org>
@@ -22320,13 +22392,6 @@ S:	Maintained
 F:	include/linux/psi*
 F:	kernel/sched/psi.c
 
-PROPELLER BUILD
-M:	Rong Xu <xur@google.com>
-M:	Han Shen <shenhan@google.com>
-S:	Supported
-F:	Documentation/dev-tools/propeller.rst
-F:	scripts/Makefile.propeller
-
 PRINTK
 M:	Petr Mladek <pmladek@suse.com>
 M:	John Ogness <john.ogness@linutronix.de>
@@ -22368,6 +22433,13 @@ F:	tools/testing/selftests/sysctl/*
 F:	lib/test_sysctl.c
 F:	scripts/check-sysctl-docs
 
+PROPELLER BUILD
+M:	Rong Xu <xur@google.com>
+M:	Han Shen <shenhan@google.com>
+S:	Supported
+F:	Documentation/dev-tools/propeller.rst
+F:	scripts/Makefile.propeller
+
 PS3 NETWORK SUPPORT
 M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
@@ -22826,6 +22898,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
 F:	drivers/net/wireless/ath/ath9k/
 
+QUALCOMM ATHEROS QCA7K ETHERNET DRIVER
+M:	Stefan Wahren <wahrenst@gmx.net>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/qca,qca7000.yaml
+F:	drivers/net/ethernet/qualcomm/qca*
+
 QUALCOMM ATHEROS QCA8K DSA SWITCH DRIVER
 M:	Christian Marangi <ansuelsmth@gmail.com>
 L:	netdev@vger.kernel.org
@@ -22834,13 +22913,6 @@ F:	Documentation/devicetree/bindings/net
 F:	drivers/net/dsa/qca/qca8k*
 F:	net/dsa/tag_qca.c
 
-QUALCOMM ATHEROS QCA7K ETHERNET DRIVER
-M:	Stefan Wahren <wahrenst@gmx.net>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/net/qca,qca7000.yaml
-F:	drivers/net/ethernet/qualcomm/qca*
-
 QUALCOMM BAM-DMUX WWAN NETWORK DRIVER
 M:	Stephan Gerhold <stephan@gerhold.net>
 L:	netdev@vger.kernel.org
@@ -22969,15 +23041,6 @@ L:	dmaengine@vger.kernel.org
 S:	Supported
 F:	drivers/dma/qcom/hidma*
 
-QUALCOMM I2C QCOM GENI DRIVER
-M:	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
-M:	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
-L:	linux-i2c@vger.kernel.org
-L:	linux-arm-msm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml
-F:	drivers/i2c/busses/i2c-qcom-geni.c
-
 QUALCOMM I2C CCI DRIVER
 M:	Loic Poulain <loic.poulain@oss.qualcomm.com>
 M:	Robert Foss <rfoss@kernel.org>
@@ -22987,6 +23050,15 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/i2c/qcom,i2c-cci.yaml
 F:	drivers/i2c/busses/i2c-qcom-cci.c
 
+QUALCOMM I2C QCOM GENI DRIVER
+M:	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
+M:	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
+L:	linux-i2c@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml
+F:	drivers/i2c/busses/i2c-qcom-geni.c
+
 QUALCOMM INLINE CRYPTO ENGINE DRIVER
 M:	Abel Vesa <abelvesa@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
@@ -23055,6 +23127,17 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/media/qcom,*-iris.yaml
 F:	drivers/media/platform/qcom/iris/
 
+QUALCOMM MEDIA PLATFORM
+M:	Bryan O'Donoghue <bod@kernel.org>
+L:	linux-media@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+S:	Supported
+Q:	https://patchwork.linuxtv.org/project/linux-media/list
+T:	git https://gitlab.freedesktop.org/linux-media/media-committers.git
+F:	Documentation/devicetree/bindings/media/*qcom*
+F:	drivers/media/platform/qcom
+F:	include/dt-bindings/media/*qcom*
+
 QUALCOMM MIPI CSI2 PHY DRIVER
 M:	Bryan O'Donoghue <bod@kernel.org>
 L:	linux-phy@lists.infradead.org
@@ -23073,17 +23156,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/mtd/qcom,nandc.yaml
 F:	drivers/mtd/nand/raw/qcom_nandc.c
 
-QUALCOMM MEDIA PLATFORM
-M:	Bryan O'Donoghue <bod@kernel.org>
-L:	linux-media@vger.kernel.org
-L:	linux-arm-msm@vger.kernel.org
-S:	Supported
-Q:	https://patchwork.linuxtv.org/project/linux-media/list
-T:	git https://gitlab.freedesktop.org/linux-media/media-committers.git
-F:	Documentation/devicetree/bindings/media/*qcom*
-F:	drivers/media/platform/qcom
-F:	include/dt-bindings/media/*qcom*
-
 QUALCOMM PAS TZ SERVICE
 M:	Sumit Garg <sumit.garg@oss.qualcomm.com>
 L:	linux-arm-msm@vger.kernel.org
@@ -23093,12 +23165,13 @@ F:	drivers/firmware/qcom/qcom_pas.h
 F:	drivers/firmware/qcom/qcom_pas_tee.c
 F:	include/linux/firmware/qcom/qcom_pas.h
 
-QUALCOMM SMB CHARGER DRIVER
-M:	Casey Connolly <casey.connolly@linaro.org>
+QUALCOMM PINCTRL DRIVERS
+M:	Bartosz Golaszewski <brgl@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/power/supply/qcom,pmi8998-charger.yaml
-F:	drivers/power/supply/qcom_smbx.c
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux.git
+F:	Documentation/devicetree/bindings/pinctrl/qcom,*.yaml
+F:	drivers/pinctrl/qcom/
 
 QUALCOMM PPE DRIVER
 M:	Luo Jie <jie.luo@oss.qualcomm.com>
@@ -23120,14 +23193,6 @@ L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
 
-QUALCOMM PINCTRL DRIVERS
-M:	Bartosz Golaszewski <brgl@kernel.org>
-L:	linux-arm-msm@vger.kernel.org
-S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux.git
-F:	Documentation/devicetree/bindings/pinctrl/qcom,*.yaml
-F:	drivers/pinctrl/qcom/
-
 QUALCOMM RMNET DRIVER
 M:	Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>
 M:	Sean Tranchetti <sean.tranchetti@oss.qualcomm.com>
@@ -23137,6 +23202,13 @@ F:	Documentation/networking/device_drive
 F:	drivers/net/ethernet/qualcomm/rmnet/
 F:	include/linux/if_rmnet.h
 
+QUALCOMM SMB CHARGER DRIVER
+M:	Casey Connolly <casey.connolly@linaro.org>
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/power/supply/qcom,pmi8998-charger.yaml
+F:	drivers/power/supply/qcom_smbx.c
+
 QUALCOMM SPMI CONTROLLER (PMIC ARBITER) DRIVER
 M:	Abel Vesa <abelvesa@kernel.org>
 M:	David Collins <david.collins@oss.qualcomm.com>
@@ -23314,6 +23386,12 @@ M:	Alexandre Bounine <alex.bou9@gmail.co
 S:	Maintained
 F:	drivers/rapidio/
 
+RAS FRU MEMORY POISON MANAGER (FMPM)
+M:	Yazen Ghannam <Yazen.Ghannam@amd.com>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	drivers/ras/amd/fmpm.c
+
 RAS INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
 M:	Borislav Petkov <bp@alien8.de>
@@ -23324,12 +23402,6 @@ F:	drivers/ras/
 F:	include/linux/ras.h
 F:	include/ras/ras_event.h
 
-RAS FRU MEMORY POISON MANAGER (FMPM)
-M:	Yazen Ghannam <Yazen.Ghannam@amd.com>
-L:	linux-edac@vger.kernel.org
-S:	Maintained
-F:	drivers/ras/amd/fmpm.c
-
 RASPBERRY PI PISP BACK END
 M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
 R:	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
@@ -23489,6 +23561,15 @@ F:	include/linux/rtc/
 F:	include/uapi/linux/rtc.h
 F:	tools/testing/selftests/rtc/
 
+Real-time Linux (PREEMPT_RT)
+M:	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
+M:	Clark Williams <clrkwllms@kernel.org>
+M:	Steven Rostedt <rostedt@goodmis.org>
+L:	linux-rt-devel@lists.linux.dev
+S:	Supported
+F:	Documentation/core-api/real-time/
+K:	PREEMPT_RT
+
 Real-time Linux Analysis (RTLA) tools
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Tomas Glozar <tglozar@redhat.com>
@@ -23500,15 +23581,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/tools/rtla/
 F:	tools/tracing/rtla/
 
-Real-time Linux (PREEMPT_RT)
-M:	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
-M:	Clark Williams <clrkwllms@kernel.org>
-M:	Steven Rostedt <rostedt@goodmis.org>
-L:	linux-rt-devel@lists.linux.dev
-S:	Supported
-F:	Documentation/core-api/real-time/
-K:	PREEMPT_RT
-
 REALTEK AUDIO CODECS
 M:	Oder Chiou <oder_chiou@realtek.com>
 S:	Maintained
@@ -23586,6 +23658,15 @@ L:	linux-wireless@vger.kernel.org
 S:	Orphan
 F:	drivers/net/wireless/rsi/
 
+REGISTER MAP ABSTRACTION
+M:	Mark Brown <broonie@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
+F:	Documentation/devicetree/bindings/regmap/
+F:	drivers/base/regmap/
+F:	include/linux/regmap.h
+
 RELAY
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Jens Axboe <axboe@kernel.dk>
@@ -23596,15 +23677,6 @@ F:	Documentation/filesystems/relay.rst
 F:	include/linux/relay.h
 F:	kernel/relay.c
 
-REGISTER MAP ABSTRACTION
-M:	Mark Brown <broonie@kernel.org>
-L:	linux-kernel@vger.kernel.org
-S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
-F:	Documentation/devicetree/bindings/regmap/
-F:	drivers/base/regmap/
-F:	include/linux/regmap.h
-
 REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM
 M:	Bjorn Andersson <andersson@kernel.org>
 M:	Mathieu Poirier <mathieu.poirier@linaro.org>
@@ -23750,6 +23822,14 @@ S:	Supported
 F:	Documentation/devicetree/bindings/i2c/renesas,riic.yaml
 F:	drivers/i2c/busses/i2c-riic.c
 
+RENESAS RTCA-3 RTC DRIVER
+M:	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
+L:	linux-rtc@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/rtc/renesas,rz-rtca3.yaml
+F:	drivers/rtc/rtc-renesas-rtca3.c
+
 RENESAS RZ AUDIO (ASoC) DRIVER
 M:	Biju Das <biju.das.jz@bp.renesas.com>
 M:	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
@@ -23759,6 +23839,15 @@ S:	Supported
 F:	Documentation/devicetree/bindings/sound/renesas,rz-ssi.yaml
 F:	sound/soc/renesas/rz-ssi.c
 
+RENESAS RZ/G2L / RZ/V2H(P) CRU
+M:	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
+M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
+L:	linux-renesas-soc@vger.kernel.org
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/renesas,rzg2l-cru.yaml
+F:	drivers/media/platform/renesas/rzg2l-cru/
+
 RENESAS RZ/G2L A/D DRIVER
 M:	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
 L:	linux-iio@vger.kernel.org
@@ -23775,30 +23864,19 @@ S:	Supported
 F:	Documentation/devicetree/bindings/timer/renesas,rz-mtu3.yaml
 F:	drivers/counter/rz-mtu3-cnt.c
 
-RENESAS RZ/G2L / RZ/V2H(P) CRU
-M:	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
-M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
-L:	linux-renesas-soc@vger.kernel.org
-L:	linux-media@vger.kernel.org
+RENESAS RZ/G3E THERMAL SENSOR UNIT DRIVER
+M:	John Madieu <john.madieu.xa@bp.renesas.com>
+L:	linux-pm@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/media/renesas,rzg2l-cru.yaml
-F:	drivers/media/platform/renesas/rzg2l-cru/
-
-RENESAS RZ/T2H / RZ/N2H A/D DRIVER
-M:	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
-L:	linux-iio@vger.kernel.org
-L:	linux-renesas-soc@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml
-F:	drivers/iio/adc/rzt2h_adc.c
+F:	Documentation/devicetree/bindings/thermal/renesas,r9a09g047-tsu.yaml
+F:	drivers/thermal/renesas/rzg3e_thermal.c
 
-RENESAS RTCA-3 RTC DRIVER
+RENESAS RZ/G3S THERMAL SENSOR UNIT DRIVER
 M:	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
-L:	linux-rtc@vger.kernel.org
-L:	linux-renesas-soc@vger.kernel.org
-S:	Supported
-F:	Documentation/devicetree/bindings/rtc/renesas,rz-rtca3.yaml
-F:	drivers/rtc/rtc-renesas-rtca3.c
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/thermal/renesas,r9a08g045-tsu.yaml
+F:	drivers/thermal/renesas/rzg3s_thermal.c
 
 RENESAS RZ/N1 A5PSW SWITCH DRIVER
 M:	Clément Léger <clement.leger@bootlin.com>
@@ -23849,6 +23927,14 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/usb/renesas,rzn1-usbf.yaml
 F:	drivers/usb/gadget/udc/renesas_usbf.c
 
+RENESAS RZ/T2H / RZ/N2H A/D DRIVER
+M:	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
+L:	linux-iio@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/iio/adc/renesas,r9a09g077-adc.yaml
+F:	drivers/iio/adc/rzt2h_adc.c
+
 RENESAS RZ/V2H(P) DWMAC GBETH GLUE LAYER DRIVER
 M:	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
 L:	netdev@vger.kernel.org
@@ -23921,20 +24007,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/potentiometer/renesas,x9250.yaml
 F:	drivers/iio/potentiometer/x9250.c
 
-RENESAS RZ/G3E THERMAL SENSOR UNIT DRIVER
-M:	John Madieu <john.madieu.xa@bp.renesas.com>
-L:	linux-pm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/thermal/renesas,r9a09g047-tsu.yaml
-F:	drivers/thermal/renesas/rzg3e_thermal.c
-
-RENESAS RZ/G3S THERMAL SENSOR UNIT DRIVER
-M:	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
-L:	linux-pm@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/thermal/renesas,r9a08g045-tsu.yaml
-F:	drivers/thermal/renesas/rzg3s_thermal.c
-
 RESET CONTROLLER FRAMEWORK
 M:	Philipp Zabel <p.zabel@pengutronix.de>
 S:	Maintained
@@ -24214,14 +24286,6 @@ F:	Documentation/ABI/*/sysfs-driver-hid-
 F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 
-ROCKCHIP CAN-FD DRIVER
-M:	Marc Kleine-Budde <mkl@pengutronix.de>
-R:	kernel@pengutronix.de
-L:	linux-can@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/net/can/rockchip,rk3568v2-canfd.yaml
-F:	drivers/net/can/rockchip/
-
 ROCKCHIP CAMERA INTERFACE (RKCIF) DRIVER
 M:	Mehdi Djait <mehdi.djait@linux.intel.com>
 M:	Michael Riesch <michael.riesch@collabora.com>
@@ -24232,6 +24296,14 @@ F:	Documentation/devicetree/bindings/med
 F:	Documentation/devicetree/bindings/media/rockchip,rk3568-vicap.yaml
 F:	drivers/media/platform/rockchip/rkcif/
 
+ROCKCHIP CAN-FD DRIVER
+M:	Marc Kleine-Budde <mkl@pengutronix.de>
+R:	kernel@pengutronix.de
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/can/rockchip,rk3568v2-canfd.yaml
+F:	drivers/net/can/rockchip/
+
 ROCKCHIP CRYPTO DRIVERS
 M:	Corentin Labbe <clabbe@baylibre.com>
 L:	linux-crypto@vger.kernel.org
@@ -24258,15 +24330,6 @@ F:	Documentation/userspace-api/media/v4l
 F:	drivers/media/platform/rockchip/rkisp1
 F:	include/uapi/linux/rkisp1-config.h
 
-ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
-M:	Daniel Golle <daniel@makrotopia.org>
-M:	Aurelien Jarno <aurelien@aurel32.net>
-M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
-F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
-F:	drivers/char/hw_random/rockchip-rng.c
-
 ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
 M:	Jacob Chen <jacob-chen@iotwrt.com>
 M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
@@ -24276,6 +24339,22 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/media/rockchip-rga.yaml
 F:	drivers/media/platform/rockchip/rga/
 
+ROCKCHIP RK3308 INTERNAL AUDIO CODEC
+M:	Luca Ceresoli <luca.ceresoli@bootlin.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/sound/rockchip,rk3308-codec.yaml
+F:	sound/soc/codecs/rk3308_codec.c
+F:	sound/soc/codecs/rk3308_codec.h
+
+ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
+M:	Daniel Golle <daniel@makrotopia.org>
+M:	Aurelien Jarno <aurelien@aurel32.net>
+M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
+F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
+F:	drivers/char/hw_random/rockchip-rng.c
+
 ROCKCHIP RKVDEC VIDEO DECODER DRIVER
 M:	Detlev Casanova <detlev.casanova@collabora.com>
 M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
@@ -24285,13 +24364,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/media/rockchip,vdec.yaml
 F:	drivers/media/platform/rockchip/rkvdec/
 
-ROCKCHIP RK3308 INTERNAL AUDIO CODEC
-M:	Luca Ceresoli <luca.ceresoli@bootlin.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/sound/rockchip,rk3308-codec.yaml
-F:	sound/soc/codecs/rk3308_codec.c
-F:	sound/soc/codecs/rk3308_codec.h
-
 ROCKCHIP SAI DRIVER
 M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
 L:	linux-rockchip@lists.infradead.org
@@ -24326,6 +24398,12 @@ M:	Matti Vaittinen <mazziesaccount@gmail
 S:	Maintained
 F:	drivers/power/supply/bd71828-power.c
 
+ROHM BD791xx ADC / GPO IC
+M:	Matti Vaittinen <mazziesaccount@gmail.com>
+S:	Supported
+F:	drivers/iio/adc/rohm-bd79112.c
+F:	drivers/iio/adc/rohm-bd79124.c
+
 ROHM BD79703 DAC
 M:	Matti Vaittinen <mazziesaccount@gmail.com>
 S:	Supported
@@ -24337,12 +24415,6 @@ S:	Supported
 F:	drivers/power/supply/bd99954-charger.c
 F:	drivers/power/supply/bd99954-charger.h
 
-ROHM BD791xx ADC / GPO IC
-M:	Matti Vaittinen <mazziesaccount@gmail.com>
-S:	Supported
-F:	drivers/iio/adc/rohm-bd79112.c
-F:	drivers/iio/adc/rohm-bd79124.c
-
 ROHM BH1745 COLOUR SENSOR
 M:	Mudit Sharma <muditsharma.info@gmail.com>
 L:	linux-iio@vger.kernel.org
@@ -24838,33 +24910,6 @@ B:	mailto:linux-samsung-soc@vger.kernel.
 F:	Documentation/devicetree/bindings/sound/samsung*
 F:	sound/soc/samsung/
 
-SAMSUNG EXYNOS2200 SoC SUPPORT
-M:	Ivaylo Ivanov <ivo.ivanov.ivanov1@gmail.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	linux-samsung-soc@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/clock/samsung,exynos2200-cmu.yaml
-F:	arch/arm64/boot/dts/exynos/exynos2200*
-F:	drivers/clk/samsung/clk-exynos2200.c
-F:	include/dt-bindings/clock/samsung,exynos2200-cmu.h
-
-SAMSUNG EXYNOS850 SoC SUPPORT
-M:	Sam Protsenko <semen.protsenko@linaro.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	linux-samsung-soc@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/clock/samsung,exynos850-clock.yaml
-F:	arch/arm64/boot/dts/exynos/exynos850*
-F:	drivers/clk/samsung/clk-exynos850.c
-F:	include/dt-bindings/clock/exynos850.h
-
-SAMSUNG EXYNOS8855 SoC SUPPORT
-M:	Alim Akhtar <alim.akhtar@samsung.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	linux-samsung-soc@vger.kernel.org
-S:	Maintained
-F:	arch/arm64/boot/dts/exynos/exynos8855*
-
 SAMSUNG EXYNOS ACPM MAILBOX PROTOCOL
 M:	Tudor Ambarus <tudor.ambarus@linaro.org>
 L:	linux-samsung-soc@vger.kernel.org
@@ -24897,6 +24942,33 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
 F:	drivers/char/hw_random/exynos-trng.c
 
+SAMSUNG EXYNOS2200 SoC SUPPORT
+M:	Ivaylo Ivanov <ivo.ivanov.ivanov1@gmail.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/clock/samsung,exynos2200-cmu.yaml
+F:	arch/arm64/boot/dts/exynos/exynos2200*
+F:	drivers/clk/samsung/clk-exynos2200.c
+F:	include/dt-bindings/clock/samsung,exynos2200-cmu.h
+
+SAMSUNG EXYNOS850 SoC SUPPORT
+M:	Sam Protsenko <semen.protsenko@linaro.org>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/clock/samsung,exynos850-clock.yaml
+F:	arch/arm64/boot/dts/exynos/exynos850*
+F:	drivers/clk/samsung/clk-exynos850.c
+F:	include/dt-bindings/clock/exynos850.h
+
+SAMSUNG EXYNOS8855 SoC SUPPORT
+M:	Alim Akhtar <alim.akhtar@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	arch/arm64/boot/dts/exynos/exynos8855*
+
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jingoohan1@gmail.com>
 L:	linux-fbdev@vger.kernel.org
@@ -25399,6 +25471,15 @@ F:	include/uapi/linux/selinux_netlink.h
 F:	scripts/selinux/
 F:	security/selinux/
 
+SENARYTECH AUDIO CODEC DRIVER
+M:	bo liu <bo.liu@senarytech.com>
+M:	qianghua.wang <qianghua.wang@senarytech.com>
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
+F:	sound/hda/codecs/senarytech.c
+F:	sound/soc/codecs/sn624x*
+F:	sound/soc/sdw_utils/soc_sdw_senary*
+
 SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@kernel.org>
 S:	Maintained
@@ -25511,6 +25592,12 @@ F:	include/linux/phylink.h
 F:	include/linux/sfp.h
 K:	phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
 
+SH_VOU V4L2 OUTPUT DRIVER
+L:	linux-media@vger.kernel.org
+S:	Orphan
+F:	drivers/media/platform/renesas/sh_vou.c
+F:	include/media/drv-intf/sh_vou.h
+
 SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	D. Wythe <alibuda@linux.alibaba.com>
 M:	Dust Li <dust.li@linux.alibaba.com>
@@ -25539,28 +25626,6 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/i2c/rj54n1cb0c.c
 F:	include/media/i2c/rj54n1cb0c.h
 
-MEMORY MANAGEMENT - SHRINKER
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Dave Chinner <david@fromorbit.com>
-R:	Qi Zheng <qi.zheng@linux.dev>
-R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Muchun Song <muchun.song@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
-F:	include/linux/list_lru.h
-F:	include/linux/shrinker.h
-F:	mm/list_lru.c
-F:	mm/shrinker.c
-F:	mm/shrinker_debug.c
-F:	tools/cgroup/memcg_shrinker.py
-
-SH_VOU V4L2 OUTPUT DRIVER
-L:	linux-media@vger.kernel.org
-S:	Orphan
-F:	drivers/media/platform/renesas/sh_vou.c
-F:	include/media/drv-intf/sh_vou.h
-
 SI2157 MEDIA DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
@@ -25775,36 +25840,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
-MEMORY MANAGEMENT - SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry@kernel.org>
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Hao Li <hao.li@linux.dev>
-R:	Christoph Lameter <cl@gentwo.org>
-R:	David Rientjes <rientjes@google.com>
-R:	Roman Gushchin <roman.gushchin@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
-F:	Documentation/ABI/testing/sysfs-kernel-slab
-F:	Documentation/admin-guide/mm/slab.rst
-F:	Documentation/mm/slab.rst
-F:	include/linux/mempool.h
-F:	include/linux/slab.h
-F:	include/trace/events/kmem.h
-F:	lib/tests/slub_kunit.c
-F:	mm/failslab.c
-F:	mm/mempool.c
-F:	mm/slab.h
-F:	mm/slab_common.c
-F:	mm/slub.c
-F:	scripts/gdb/linux/slab.py
-F:	tools/cgroup/memcg_slabinfo.py
-F:	tools/include/linux/slab.h
-F:	tools/lib/slab.c
-F:	tools/mm/slabinfo-gnuplot.sh
-F:	tools/mm/slabinfo.c
-
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
 L:	linux-can@vger.kernel.org
@@ -26245,12 +26280,21 @@ F:	include/sound/dmaengine_pcm.h
 F:	sound/core/pcm_dmaengine.c
 F:	sound/soc/soc-generic-dmaengine-pcm.c
 
-SOUND - SOC LAYER / GPIO AUDIO AMPLIFIER
-M:	Herve Codina <herve.codina@bootlin.com>
+SOUND - GENERIC SOUND CARD (Simple-Audio-Card, Audio-Graph-Card)
+M:	Mark Brown <broonie@kernel.org>
+M:	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+S:	Supported
+L:	linux-sound@vger.kernel.org
+F:	sound/soc/generic/
+F:	include/sound/simple_card*
+F:	Documentation/devicetree/bindings/sound/simple-card.yaml
+F:	Documentation/devicetree/bindings/sound/audio-graph*.yaml
+
+SOUND - SOC LAYER / dapm-graph
+M:	Luca Ceresoli <luca.ceresoli@bootlin.com>
 L:	linux-sound@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/sound/gpio-audio-amp.yaml
-F:	sound/soc/codecs/simple-amplifier.c
+F:	tools/sound/dapm-graph
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
 M:	Liam Girdwood <lgirdwood@gmail.com>
@@ -26275,11 +26319,12 @@ F:	include/trace/events/sof*.h
 F:	include/uapi/sound/asoc.h
 F:	sound/soc/
 
-SOUND - SOC LAYER / dapm-graph
-M:	Luca Ceresoli <luca.ceresoli@bootlin.com>
+SOUND - SOC LAYER / GPIO AUDIO AMPLIFIER
+M:	Herve Codina <herve.codina@bootlin.com>
 L:	linux-sound@vger.kernel.org
 S:	Maintained
-F:	tools/sound/dapm-graph
+F:	Documentation/devicetree/bindings/sound/gpio-audio-amp.yaml
+F:	sound/soc/codecs/simple-amplifier.c
 
 SOUND - SOUND OPEN FIRMWARE (SOF) DRIVERS
 M:	Liam Girdwood <lgirdwood@gmail.com>
@@ -26294,16 +26339,6 @@ S:	Supported
 W:	https://github.com/thesofproject/linux/
 F:	sound/soc/sof/
 
-SOUND - GENERIC SOUND CARD (Simple-Audio-Card, Audio-Graph-Card)
-M:	Mark Brown <broonie@kernel.org>
-M:	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
-S:	Supported
-L:	linux-sound@vger.kernel.org
-F:	sound/soc/generic/
-F:	include/sound/simple_card*
-F:	Documentation/devicetree/bindings/sound/simple-card.yaml
-F:	Documentation/devicetree/bindings/sound/audio-graph*.yaml
-
 SOUNDWIRE SUBSYSTEM
 M:	Vinod Koul <vkoul@kernel.org>
 M:	Bard Liao <yung-chuan.liao@linux.intel.com>
@@ -26747,6 +26782,14 @@ F:	Documentation/devicetree/bindings/clo
 F:	drivers/clk/starfive/clk-starfive-jh71*
 F:	include/dt-bindings/clock/starfive?jh71*.h
 
+STARFIVE JH71X0 PCIE AND USB PHY DRIVER
+M:	Minda Chen <minda.chen@starfivetech.com>
+S:	Supported
+F:	Documentation/devicetree/bindings/phy/starfive,jh7110-pcie-phy.yaml
+F:	Documentation/devicetree/bindings/phy/starfive,jh7110-usb-phy.yaml
+F:	drivers/phy/starfive/phy-jh7110-pcie.c
+F:	drivers/phy/starfive/phy-jh7110-usb.c
+
 STARFIVE JH71X0 PINCTRL DRIVERS
 M:	Emil Renner Berthing <kernel@esmil.dk>
 M:	Hal Feng <hal.feng@starfivetech.com>
@@ -26765,13 +26808,6 @@ F:	Documentation/devicetree/bindings/res
 F:	drivers/reset/starfive/reset-starfive-jh71*
 F:	include/dt-bindings/reset/starfive?jh71*.h
 
-STARFIVE USB DRIVERS
-M:	Minda Chen <minda.chen@starfivetech.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/usb/starfive,jh7110-usb.yaml
-F:	Documentation/devicetree/bindings/usb/starfive,jhb100-dwc3.yaml
-F:	drivers/usb/cdns3/cdns3-starfive.c
-
 STARFIVE JH71XX PMU CONTROLLER DRIVER
 M:	Walker Chen <walker.chen@starfivetech.com>
 M:	Changhuang Liang <changhuang.liang@starfivetech.com>
@@ -26780,6 +26816,20 @@ F:	Documentation/devicetree/bindings/pow
 F:	drivers/pmdomain/starfive/
 F:	include/dt-bindings/power/starfive,jh7110-pmu.h
 
+STARFIVE JHB100 EXTERNAL INTERRUPT CONTROLLER DRIVER
+M:	Changhuang Liang <changhuang.liang@starfivetech.com>
+S:	Supported
+F:	Documentation/devicetree/bindings/interrupt-controller/starfive,jhb100-intc.yaml
+F:	drivers/irqchip/irq-starfive-jhb100-intc.c
+
+STARFIVE JHB100 PINCTRL DRIVERS
+M:	Changhuang Liang <changhuang.liang@starfivetech.com>
+M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
+L:	linux-gpio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/pinctrl/starfive,jhb1*.yaml
+F:	drivers/pinctrl/starfive/pinctrl-starfive-jhb1*
+
 STARFIVE SOC DRIVERS
 M:	Conor Dooley <conor@kernel.org>
 S:	Maintained
@@ -26799,6 +26849,13 @@ S:	Supported
 F:	Documentation/devicetree/bindings/rng/starfive*
 F:	drivers/char/hw_random/jh7110-trng.c
 
+STARFIVE USB DRIVERS
+M:	Minda Chen <minda.chen@starfivetech.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/usb/starfive,jh7110-usb.yaml
+F:	Documentation/devicetree/bindings/usb/starfive,jhb100-dwc3.yaml
+F:	drivers/usb/cdns3/cdns3-starfive.c
+
 STARFIVE WATCHDOG DRIVER
 M:	Xingyu Wu <xingyu.wu@starfivetech.com>
 M:	Ziv Xu <ziv.xu@starfivetech.com>
@@ -26806,28 +26863,6 @@ S:	Supported
 F:	Documentation/devicetree/bindings/watchdog/starfive*
 F:	drivers/watchdog/starfive-wdt.c
 
-STARFIVE JH71X0 PCIE AND USB PHY DRIVER
-M:	Minda Chen <minda.chen@starfivetech.com>
-S:	Supported
-F:	Documentation/devicetree/bindings/phy/starfive,jh7110-pcie-phy.yaml
-F:	Documentation/devicetree/bindings/phy/starfive,jh7110-usb-phy.yaml
-F:	drivers/phy/starfive/phy-jh7110-pcie.c
-F:	drivers/phy/starfive/phy-jh7110-usb.c
-
-STARFIVE JHB100 EXTERNAL INTERRUPT CONTROLLER DRIVER
-M:	Changhuang Liang <changhuang.liang@starfivetech.com>
-S:	Supported
-F:	Documentation/devicetree/bindings/interrupt-controller/starfive,jhb100-intc.yaml
-F:	drivers/irqchip/irq-starfive-jhb100-intc.c
-
-STARFIVE JHB100 PINCTRL DRIVERS
-M:	Changhuang Liang <changhuang.liang@starfivetech.com>
-M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
-L:	linux-gpio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/pinctrl/starfive,jhb1*.yaml
-F:	drivers/pinctrl/starfive/pinctrl-starfive-jhb1*
-
 STATIC BRANCH/CALL
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
@@ -27283,6 +27318,16 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/system76_acpi.c
 
+TASK DELAY MONITORING TOOLS
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Wang Yaxin <wang.yaxin@zte.com.cn>
+M:	Fan Yu <fan.yu9@zte.com.cn>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/accounting/delay-accounting.rst
+F:	tools/accounting/delaytop.c
+F:	tools/accounting/getdelays.c
+
 TASKSTATS STATISTICS INTERFACE
 M:	Balbir Singh <bsingharora@gmail.com>
 S:	Maintained
@@ -27660,14 +27705,6 @@ F:	include/linux/dma/k3-udma-glue.h
 F:	include/linux/dma/ti-cppi5.h
 X:	drivers/dma/ti/cppi41.c
 
-TEXAS INSTRUMENTS TPS25990 HARDWARE MONITOR DRIVER
-M:	Jerome Brunet <jbrunet@baylibre.com>
-L:	linux-hwmon@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/hwmon/pmbus/ti,tps25990.yaml
-F:	Documentation/hwmon/tps25990.rst
-F:	drivers/hwmon/pmbus/tps25990.c
-
 TEXAS INSTRUMENTS TPS23861 PoE PSE DRIVER
 M:	Robert Marko <robert.marko@sartura.hr>
 M:	Luka Perkov <luka.perkov@sartura.hr>
@@ -27677,6 +27714,14 @@ F:	Documentation/devicetree/bindings/hwm
 F:	Documentation/hwmon/tps23861.rst
 F:	drivers/hwmon/tps23861.c
 
+TEXAS INSTRUMENTS TPS25990 HARDWARE MONITOR DRIVER
+M:	Jerome Brunet <jbrunet@baylibre.com>
+L:	linux-hwmon@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/hwmon/pmbus/ti,tps25990.yaml
+F:	Documentation/hwmon/tps25990.rst
+F:	drivers/hwmon/pmbus/tps25990.c
+
 TEXAS INSTRUMENTS TPS6131X FLASH LED DRIVER
 M:	Matthias Fend <matthias.fend@emfend.at>
 L:	linux-leds@vger.kernel.org
@@ -27691,6 +27736,13 @@ S:	Supported
 F:	Documentation/devicetree/bindings/iio/dac/ti,dac7612.yaml
 F:	drivers/iio/dac/ti-dac7612.c
 
+TEXAS INSTRUMENTS' LB8864 LED BACKLIGHT DRIVER
+M:	Alexander Sverdlin <alexander.sverdlin@siemens.com>
+L:	linux-leds@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/leds/backlight/ti,lp8864.yaml
+F:	drivers/leds/leds-lp8864.c
+
 TEXAS INSTRUMENTS' LP5812 RGB LED DRIVER
 M:	Nam Tran <trannamatk@gmail.com>
 L:	linux-leds@vger.kernel.org
@@ -27702,13 +27754,6 @@ F:	drivers/leds/rgb/Makefile
 F:	drivers/leds/rgb/leds-lp5812.c
 F:	drivers/leds/rgb/leds-lp5812.h
 
-TEXAS INSTRUMENTS' LB8864 LED BACKLIGHT DRIVER
-M:	Alexander Sverdlin <alexander.sverdlin@siemens.com>
-L:	linux-leds@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/leds/backlight/ti,lp8864.yaml
-F:	drivers/leds/leds-lp8864.c
-
 TEXAS INSTRUMENTS' SYSTEM CONTROL INTERFACE (TISCI) PROTOCOL DRIVER
 M:	Nishanth Menon <nm@ti.com>
 M:	Tero Kristo <kristo@kernel.org>
@@ -27809,12 +27854,6 @@ W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 F:	drivers/platform/x86/lenovo/thinkpad_acpi.c
 
-THINKPAD T14S EMBEDDED CONTROLLER DRIVER
-M:	Sebastian Reichel <sre@kernel.org>
-S:	Maintained
-F:	Documentation/devicetree/bindings/embedded-controller/lenovo,thinkpad-t14s-ec.yaml
-F:	drivers/platform/arm64/lenovo-thinkpad-t14s.c
-
 THINKPAD LMI DRIVER
 M:	Mark Pearson <mpearson-lenovo@squebb.ca>
 L:	platform-driver-x86@vger.kernel.org
@@ -27822,6 +27861,12 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-class-firmware-attributes
 F:	drivers/platform/x86/lenovo/think-lmi.?
 
+THINKPAD T14S EMBEDDED CONTROLLER DRIVER
+M:	Sebastian Reichel <sre@kernel.org>
+S:	Maintained
+F:	Documentation/devicetree/bindings/embedded-controller/lenovo,thinkpad-t14s-ec.yaml
+F:	drivers/platform/arm64/lenovo-thinkpad-t14s.c
+
 THP7312 ISP DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 M:	Paul Elder <paul.elder@ideasonboard.com>
@@ -27868,6 +27913,13 @@ S:	Maintained
 F:	drivers/iio/adc/ti-adc128s052.c
 L:	linux-iio@vger.kernel.org
 
+TI ADS1018 ADC DRIVER
+M:	Kurt Borja <kuurtb@gmail.com>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/iio/adc/ti,ads1018.yaml
+F:	drivers/iio/adc/ti-ads1018.c
+
 TI ADS1119 ADC DRIVER
 M:	Francesco Dolcini <francesco@dolcini.it>
 M:	João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
@@ -27890,13 +27942,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/adc/ti,ads112c14.yaml
 F:	drivers/iio/adc/ti-ads112c14.c
 
-TI ADS1018 ADC DRIVER
-M:	Kurt Borja <kuurtb@gmail.com>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/adc/ti,ads1018.yaml
-F:	drivers/iio/adc/ti-ads1018.c
-
 TI ADS7924 ADC DRIVER
 M:	Hugo Villeneuve <hvilleneuve@dimonoff.com>
 L:	linux-iio@vger.kernel.org
@@ -28885,15 +28930,6 @@ F:	include/uapi/linux/usb/g_*.h
 F:	include/uapi/linux/usb/gadgetfs.h
 F:	tools/usb/ffs-*
 
-USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
-M:	Jiri Kosina <jikos@kernel.org>
-M:	Benjamin Tissoires <bentiss@kernel.org>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git
-F:	Documentation/hid/hiddev.rst
-F:	drivers/hid/usbhid/
-
 USB HID PID DRIVERS (USB WHEELBASES, JOYSTICKS, RUDDERS, ...)
 M:	Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
 M:	Oleg Makarenko <oleg@makarenk.ooo>
@@ -28903,6 +28939,15 @@ B:	https://github.com/JacKeTUs/universal
 F:	drivers/hid/usbhid/hid-pidff*
 F:	drivers/hid/hid-universal-pidff.c
 
+USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
+M:	Jiri Kosina <jikos@kernel.org>
+M:	Benjamin Tissoires <bentiss@kernel.org>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git
+F:	Documentation/hid/hiddev.rst
+F:	drivers/hid/usbhid/
+
 USB INTEL XHCI ROLE MUX DRIVER
 M:	Hans de Goede <hansg@kernel.org>
 L:	linux-usb@vger.kernel.org
@@ -29255,14 +29300,6 @@ F:	drivers/media/v4l2-core/v4l2-fwnode.c
 F:	include/media/v4l2-async.h
 F:	include/media/v4l2-fwnode.h
 
-V4L2 LENS DRIVERS
-M:	Sakari Ailus <sakari.ailus@linux.intel.com>
-L:	linux-media@vger.kernel.org
-S:	Maintained
-F:	drivers/media/i2c/ak*
-F:	drivers/media/i2c/dw*
-F:	drivers/media/i2c/lm*
-
 V4L2 CAMERA SENSOR DRIVERS
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 L:	linux-media@vger.kernel.org
@@ -29291,6 +29328,14 @@ F:	drivers/media/v4l2-core/v4l2-isp.c
 F:	include/media/v4l2-isp.h
 F:	include/uapi/linux/media/v4l2-isp.h
 
+V4L2 LENS DRIVERS
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/ak*
+F:	drivers/media/i2c/dw*
+F:	drivers/media/i2c/lm*
+
 VERISILICON IOMMU DRIVER
 M:	Benjamin Gaignard <benjamin.gaignard@collabora.com>
 L:	iommu@lists.linux.dev
@@ -29633,6 +29678,16 @@ F:	drivers/gpu/drm/ci/xfails/virtio*
 F:	drivers/gpu/drm/virtio/
 F:	include/uapi/linux/virtio_gpu.h
 
+VIRTIO HOST (VHOST-SCSI)
+M:	"Michael S. Tsirkin" <mst@redhat.com>
+M:	Jason Wang <jasowangio@gmail.com>
+M:	Mike Christie <michael.christie@oracle.com>
+R:	Paolo Bonzini <pbonzini@redhat.com>
+R:	Stefan Hajnoczi <stefanha@redhat.com>
+L:	virtualization@lists.linux.dev
+S:	Maintained
+F:	drivers/vhost/scsi.c
+
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 M:	Jason Wang <jasowangio@gmail.com>
@@ -29648,16 +29703,6 @@ F:	include/linux/vhost_iotlb.h
 F:	include/uapi/linux/vhost.h
 F:	kernel/vhost_task.c
 
-VIRTIO HOST (VHOST-SCSI)
-M:	"Michael S. Tsirkin" <mst@redhat.com>
-M:	Jason Wang <jasowangio@gmail.com>
-M:	Mike Christie <michael.christie@oracle.com>
-R:	Paolo Bonzini <pbonzini@redhat.com>
-R:	Stefan Hajnoczi <stefanha@redhat.com>
-L:	virtualization@lists.linux.dev
-S:	Maintained
-F:	drivers/vhost/scsi.c
-
 VIRTIO I2C DRIVER
 M:	Viresh Kumar <viresh.kumar@linaro.org>
 R:	"Chen, Jian Jun" <jian.jun.chen@intel.com>
@@ -29831,20 +29876,6 @@ F:	net/vmw_vsock/
 F:	tools/testing/selftests/vsock/
 F:	tools/testing/vsock/
 
-MEMORY MANAGEMENT - VMALLOC
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Uladzislau Rezki <urezki@gmail.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	include/linux/vmalloc.h
-F:	include/trace/events/vmalloc.h
-F:	lib/test_vmalloc.c
-F:	mm/vmalloc.c
-F:	mm/vmalloc.h
-F:	scripts/gdb/linux/vmalloc.py
-
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
@@ -30604,14 +30635,6 @@ S:	Maintained
 F:	drivers/pwm/pwm-xilinx.c
 F:	include/clocksource/timer-xilinx.h
 
-XILINX SOUND DRIVERS
-M:	Vincenzo Frascino <vincenzo.frascino@arm.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/sound/xlnx,i2s.yaml
-F:	Documentation/devicetree/bindings/sound/xlnx,audio-formatter.yaml
-F:	Documentation/devicetree/bindings/sound/xlnx,spdif.yaml
-F:	sound/soc/xilinx/*
-
 XILINX SD-FEC IP CORES
 M:	Derek Kiernan <derek.kiernan@amd.com>
 M:	Dragan Cvetic <dragan.cvetic@amd.com>
@@ -30631,6 +30654,14 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/interrupt-controller/xlnx,versal-net-smmu-csr.yaml
 F:	drivers/irqchip/irq-xilinx-smmu-csr.c
 
+XILINX SOUND DRIVERS
+M:	Vincenzo Frascino <vincenzo.frascino@arm.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/sound/xlnx,i2s.yaml
+F:	Documentation/devicetree/bindings/sound/xlnx,audio-formatter.yaml
+F:	Documentation/devicetree/bindings/sound/xlnx,spdif.yaml
+F:	sound/soc/xilinx/*
+
 XILINX TRNG DRIVER
 M:	Mounika Botcha <mounika.botcha@amd.com>
 M:	Harsh Jain <h.jain@amd.com>
@@ -30643,15 +30674,6 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/uartlite.c
 
-XILINX VIDEO IP CORES
-M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-L:	linux-media@vger.kernel.org
-S:	Supported
-T:	git git://linuxtv.org/media.git
-F:	Documentation/devicetree/bindings/media/xilinx/
-F:	drivers/media/platform/xilinx/
-F:	include/uapi/linux/xilinx-v4l2-controls.h
-
 XILINX VERSAL EDAC DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
 M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
@@ -30660,6 +30682,14 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/memory-controllers/xlnx,versal-ddrmc-edac.yaml
 F:	drivers/edac/versal_edac.c
 
+XILINX VERSAL SYSMON DRIVER
+M:	Salih Erim <salih.erim@amd.com>
+M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
+L:	linux-iio@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/iio/adc/xlnx,versal-sysmon.yaml
+F:	drivers/iio/adc/versal-sysmon*
+
 XILINX VERSALNET EDAC DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
 R:	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
@@ -30668,13 +30698,14 @@ F:	Documentation/devicetree/bindings/mem
 F:	drivers/edac/versalnet_edac.c
 F:	include/linux/cdx/edac_cdx_pcol.h
 
-XILINX VERSAL SYSMON DRIVER
-M:	Salih Erim <salih.erim@amd.com>
-M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
-L:	linux-iio@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/iio/adc/xlnx,versal-sysmon.yaml
-F:	drivers/iio/adc/versal-sysmon*
+XILINX VIDEO IP CORES
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+T:	git git://linuxtv.org/media.git
+F:	Documentation/devicetree/bindings/media/xilinx/
+F:	drivers/media/platform/xilinx/
+F:	include/uapi/linux/xilinx-v4l2-controls.h
 
 XILINX WATCHDOG DRIVER
 M:	Srinivas Neeli <srinivas.neeli@amd.com>
@@ -30705,6 +30736,14 @@ F:	Documentation/devicetree/bindings/dma
 F:	drivers/dma/xilinx/xilinx_dpdma.c
 F:	include/dt-bindings/dma/xlnx-zynqmp-dpdma.h
 
+XILINX ZYNQMP NVMEM DRIVER
+M:	Praveen Teja Kundanala <praveen.teja.kundanala@amd.com>
+M:	Kalyani Akula <kalyani.akula@amd.com>
+R:	Michal Simek <michal.simek@amd.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml
+F:	drivers/nvmem/zynqmp_nvmem.c
+
 XILINX ZYNQMP OCM EDAC DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
 M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
@@ -30727,14 +30766,6 @@ M:	Harsha <harsha.harsha@amd.com>
 S:	Maintained
 F:	drivers/crypto/xilinx/zynqmp-sha.c
 
-XILINX ZYNQMP NVMEM DRIVER
-M:	Praveen Teja Kundanala <praveen.teja.kundanala@amd.com>
-M:	Kalyani Akula <kalyani.akula@amd.com>
-R:	Michal Simek <michal.simek@amd.com>
-S:	Maintained
-F:	Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml
-F:	drivers/nvmem/zynqmp_nvmem.c
-
 XILLYBUS DRIVER
 M:	Eli Billauer <eli.billauer@gmail.com>
 L:	linux-kernel@vger.kernel.org
@@ -30864,16 +30895,6 @@ M:	"Maciej W. Rozycki" <macro@orcam.me.u
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
-MEMORY MANAGEMENT - ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
-M:	Minchan Kim <minchan@kernel.org>
-M:	Sergey Senozhatsky <senozhatsky@chromium.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/mm/zsmalloc.rst
-F:	include/linux/zsmalloc.h
-F:	mm/zpdesc.h
-F:	mm/zsmalloc.c
-
 ZSTD
 M:	Nick Terrell <terrelln@fb.com>
 M:	David Sterba <dsterba@suse.com>
@@ -30887,27 +30908,6 @@ F:	lib/zstd/
 N:	zstd
 K:	zstd
 
-MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
-M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosry@kernel.org>
-M:	Nhat Pham <nphamcs@gmail.com>
-R:	Chengming Zhou <chengming.zhou@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/admin-guide/mm/zswap.rst
-F:	include/linux/zswap.h
-F:	mm/zswap.c
-F:	tools/testing/selftests/cgroup/test_zswap.c
-
-SENARYTECH AUDIO CODEC DRIVER
-M:	bo liu <bo.liu@senarytech.com>
-M:	qianghua.wang <qianghua.wang@senarytech.com>
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
-F:	sound/hda/codecs/senarytech.c
-F:	sound/soc/codecs/sn624x*
-F:	sound/soc/sdw_utils/soc_sdw_senary*
-
 ZTE DINGHAI ETHERNET DRIVER
 M:	Junyang Han <han.junyang@zte.com.cn>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maintainers-use-a-common-prefix-for-mm-components.patch
maintainers-sort-component-entries-alphabetically.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

