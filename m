Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D624C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 06:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320E2207EA
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 06:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599200627;
	bh=FrT/GI2T5GJFRBg9MVQb2IZYKNwcz8EkP4DyAMXYTZY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yOiSkzpE+/JAQrmhP2zBlVxbCBdqu/ujAZXRnuEhf/vToDZKK0MAn2ogXVPTGlhB9
	 UeFCfFhzrjsTvcv8UlmTtaW9TBVx8XbhzZw5Vw8pgDE7rLqBIOPBj947Vsf16fgIua
	 pitiAia9j+jTFYOKpnAbfV7eM+dGUnrDpi65Kz6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIDGXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 02:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgIDGXq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 02:23:46 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7A0206E7;
        Fri,  4 Sep 2020 06:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599200626;
        bh=FrT/GI2T5GJFRBg9MVQb2IZYKNwcz8EkP4DyAMXYTZY=;
        h=Date:From:To:Subject:From;
        b=v1a5XrclgkUQXS82eMoIRE8Hvlj2hUUUz6EZDLJS5cbMkDlnQIwngFgCz1X0eAHvD
         kWJCMkAXSmKgLEwQmuF243O5pSpBwyDA9KGOjwsppqniMIGISKTpNmHH6VTcBCIPt5
         I5H2/K7FYwDdFQn1cWjnjCtHGzx2tnSfp8FGdhJ8=
Date:   Thu, 03 Sep 2020 23:23:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        lkp@intel.com, dan.j.williams@intel.com, joao.m.martins@oracle.com
Subject:  +
 acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch added to -mm
 tree
Message-ID: <20200904062344.IwjZ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: require NUMA_KEEP_MEMINFO for phys_to_target_node()
has been added to the -mm tree.  Its filename is
     acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: require NUMA_KEEP_MEMINFO for phys_to_target_node()

phys_to_target_node() and memory_add_physaddr_to_nid() are only defined
with both CONFIG_NUMA=y and CONFIG_MEMORY_HOTPLUG=y.  Oherwise we see:

drivers/dax/hmem/device.o: in function `hmem_register_one':
drivers/dax/hmem/device.c:85: undefined reference to `phys_to_target_node'

lkp also reports such build failures:

ld.lld: error: undefined symbol: phys_to_target_node

X86 is a special case in which both can be defined without depending on
MEMORY_HOTPLUG=y. The other case is powerpc (for
memory_add_physaddr_to_nid) but like ARM64 dependencies, the
arch-specific override requires CONFIG_NUMA and CONFIG_MEMORY_HOTPLUG.

In all cases this ends up depending on CONFIG_NUMA_KEEP_MEMINFO to
signal the presence of phys_to_target_node() which is what
CONFIG_DEV_DAX_HMEM_DEVICES should depend on. Additionally, the X86
arch-override is not selected unless X86_PMEM_LEGACY=y. So on
CONFIG_DEV_DAX_HMEM we select CONFIG_NUMA_KEEP_INFO ourselves if both
NUMA and X86 are set.

Link: https://lkml.kernel.org/r/aaae71a7-4846-f5cc-5acf-cf05fdb1f2dc@oracle.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dax/Kconfig~acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix
+++ a/drivers/dax/Kconfig
@@ -35,6 +35,7 @@ config DEV_DAX_PMEM
 config DEV_DAX_HMEM
 	tristate "HMEM DAX: direct access to 'specific purpose' memory"
 	depends on EFI_SOFT_RESERVE
+	select NUMA_KEEP_MEMINFO if (NUMA && X86)
 	default DEV_DAX
 	help
 	  EFI 2.8 platforms, and others, may advertise 'specific purpose'
@@ -49,6 +50,7 @@ config DEV_DAX_HMEM
 	  Say M if unsure.
 
 config DEV_DAX_HMEM_DEVICES
+	depends on NUMA_KEEP_MEMINFO # for phys_to_target_node()
 	depends on DEV_DAX_HMEM && DAX=y
 	def_bool y
 
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-add-dis-contiguous-resource-support-fix.patch
device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute.patch
device-dax-add-an-align-attribute-fixpatch.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

