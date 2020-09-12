Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077F2C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4EC20732
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927938;
	bh=0bcvvIBuPqSxi/disfFz4htng0ft943UAFn3vfnhpqg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RUopLwgYMvNFAm1eWqGqfoLZ1rEsczpfyaGsliACWtOJaCEjIeJNbV6xRSdFK6Hdp
	 laEc2Mxe8e2d3ijWbsPOGG96blgUvGwRUPZycXA0dzA47XG3NuP+uUhDr/dq5p6aTF
	 S38rPSekpvdx/ooAw1P5SI2Cf833YYxxD25JK5+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgILQZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgILQYR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CA5221E3;
        Sat, 12 Sep 2020 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927856;
        bh=0bcvvIBuPqSxi/disfFz4htng0ft943UAFn3vfnhpqg=;
        h=Date:From:To:Subject:From;
        b=f002lRNCFsBc/OCoEkiL9Ca9+fe33qAO0vi4wLJNzayHsJSh9qpmp8vDQYNQhozFp
         /d7PE+yPELiCECzsIQGLfRFVy6OEq6wz6UPh7zgf5NU+IAU6T3S+uDIsHckvkZMlub
         hIpzC3VXCX2ANRsqr+85eZl0pZCx5n8gCR+47dEA=
Date:   Sat, 12 Sep 2020 09:24:16 -0700
From:   akpm@linux-foundation.org
To:     daniel.diaz@linaro.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sedat.dilek@gmail.com
Subject:  [merged]
 x86-defconfigs-explicitly-unset-config_64bit-in-i386_defconfig.patch
 removed from -mm tree
Message-ID: <20200912162416.uvMscSThM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/defconfigs: Explicitly unset CONFIG_64BIT in i386_defconf=
ig
has been removed from the -mm tree.  Its filename was
     x86-defconfigs-explicitly-unset-config_64bit-in-i386_defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
Subject: x86/defconfigs: Explicitly unset CONFIG_64BIT in i386_defconfig

A recent refresh of the defconfigs got rid of the following (unset)
config:

  # CONFIG_64BIT is not set

Innocuous as it seems, when the config file is saved again the
behavior is changed so that CONFIG_64BIT=3Dy.

Currently,

  $ make i386_defconfig
  $ grep CONFIG_64BIT .config
  CONFIG_64BIT=3Dy

whereas previously (and with this patch):

  $ make i386_defconfig
  $ grep CONFIG_64BIT .config
  # CONFIG_64BIT is not set

This was found with weird compiler errors on OpenEmbedded
builds, as the compiler was unable to cope with 64-bits data
types:

  NOTE: make -j1 bzImage CC=3Di686-linaro-linux-gcc  -fuse-ld=3Dbfd -fdebug=
-prefix-map=3D/oe/build/tmp/work/intel_core2_32-linaro-linux/linux-generic-=
mainline/5.8+gitAUTOINC+1d0e12fd3a-r0=3D/usr/src/debug/linux-generic-mainli=
ne/5.8+gitAUTOINC+1d0e12fd3a-r0 -fdebug-prefix-map=3D/oe/build/tmp/work/int=
el_core2_32-linaro-linux/linux-generic-mainline/5.8+gitAUTOINC+1d0e12fd3a-r=
0/recipe-sysroot=3D -fdebug-prefix-map=3D/oe/build/tmp/work/intel_core2_32-=
linaro-linux/linux-generic-mainline/5.8+gitAUTOINC+1d0e12fd3a-r0/recipe-sys=
root-native=3D  -fdebug-prefix-map=3D/oe/build/tmp/work-shared/intel-core2-=
32/kernel-source=3D/usr/src/kernel -ffile-prefix-map=3D/oe/build/tmp/work/i=
ntel_core2_32-linaro-linux/linux-generic-mainline/5.8+gitAUTOINC+1d0e12fd3a=
-r0/git=3D/kernel-source/  LD=3Di686-linaro-linux-ld.bfd
    GEN     Makefile
    CC      scripts/mod/empty.o
  cc1: error: code model 'kernel' not supported in the 32 bit mode
  cc1: sorry, unimplemented: 64-bit mode not compiled in
  /oe/build/tmp/work-shared/intel-core2-32/kernel-source/scripts/Makefile.b=
uild:280: recipe for target 'scripts/mod/empty.o' failed
  make[2]: *** [scripts/mod/empty.o] Error 1
  /oe/build/tmp/work-shared/intel-core2-32/kernel-source/Makefile:1174: rec=
ipe for target 'prepare0' failed
  make[1]: *** [prepare0] Error 2
  /oe/build/tmp/work-shared/intel-core2-32/kernel-source/Makefile:185: reci=
pe for target '__sub-make' failed
  make: *** [__sub-make] Error 2

Link: https://lkml.kernel.org/r/20200819173225.3821449-1-daniel.diaz@linaro=
.org
Fixes: 1d0e12fd3a84 ("x86/defconfigs: Refresh defconfig files")
Signed-off-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/configs/i386_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/configs/i386_defconfig~x86-defconfigs-explicitly-unset-confi=
g_64bit-in-i386_defconfig
+++ a/arch/x86/configs/i386_defconfig
@@ -19,6 +19,7 @@ CONFIG_CGROUP_CPUACCT=3Dy
 CONFIG_BLK_DEV_INITRD=3Dy
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=3Dy
+# CONFIG_64BIT is not set
 CONFIG_SMP=3Dy
 CONFIG_X86_GENERIC=3Dy
 CONFIG_HPET_TIMER=3Dy
_

Patches currently in -mm which might be from daniel.diaz@linaro.org are


