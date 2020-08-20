Return-Path: <SRS0=nxWc=B6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018C0C433DF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 21:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA91214F1
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 21:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597958983;
	bh=rO1l3bOFbfYvxSddRtAvsykmg0maLoqZv90aymSuSNk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eLUZ4sdCqpDuCw4o9NxacmBypLwdqhVptL7PzSXg8GwUPMQHIkjG8lR3qso2Z7Ybw
	 PrKZkgoayFEn3bJtKrOXJbbBVtpDv/nCvc4HHwRVbZcQCfdHkQJy7wNCrZb07b8rQm
	 wbbbI1LDNKtyKXH7TvfUsVqwcls5kNiYMYiGwur0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHTV3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 17:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgHTV3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 17:29:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804A020885;
        Thu, 20 Aug 2020 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597958981;
        bh=rO1l3bOFbfYvxSddRtAvsykmg0maLoqZv90aymSuSNk=;
        h=Date:From:To:Subject:From;
        b=xuyR/RuJ3tt82+VBbXjRQTLysvrGbN8IV7Rtroo3+hbJkOuHscsiHy3DakGnhRH4L
         aMy1OEGpl1f4D0PrEyptG8sdW3qOowV33Tkjkv/ze+NoBm0Yki6kugB9YmJK3XgGWD
         6dWh8KF0XcJiWPHV27AgKnaedj7T3xzL1anIe8j0=
Date:   Thu, 20 Aug 2020 14:29:40 -0700
From:   akpm@linux-foundation.org
To:     daniel.diaz@linaro.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sedat.dilek@gmail.com
Subject:  +
 x86-defconfigs-explicitly-unset-config_64bit-in-i386_defconfig.patch added
 to -mm tree
Message-ID: <20200820212940.Kq1ky-JHH%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     x86-defconfigs-explicitly-unset-config_64bit-in-i386_defconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-defconfigs-explicitly-uns=
et-config_64bit-in-i386_defconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-defconfigs-explicitly-uns=
et-config_64bit-in-i386_defconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

x86-defconfigs-explicitly-unset-config_64bit-in-i386_defconfig.patch

