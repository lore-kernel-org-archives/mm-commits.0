Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3553FC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05BAA2074D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599193684;
	bh=A4XZ5eNp22SjanOXxIk5RRd5Pk2GGrY4mY2yP10l+DA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jnnwRofVbg7lkDPDRWpUHSbxIm5TFaXtQ1Z16ctOuFXJRjalY/hkCCtzksWYibt8v
	 qhB1L8Kntvuu6OrBYWRR4RqgQ1r/SViZX6iN7Uy89cx7Gi/tDImwSaEY8j72YI38ZQ
	 JS7SRoP4g0UtcyMQNMXY7s3rbASAZSGIH0iUiDVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIDE2D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgIDE2D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:28:03 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C07320748;
        Fri,  4 Sep 2020 04:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599193682;
        bh=A4XZ5eNp22SjanOXxIk5RRd5Pk2GGrY4mY2yP10l+DA=;
        h=Date:From:To:Subject:From;
        b=AIQo0AS2wNwEA1MbAWFFxhSlyXSvnmbVD1SPQrxgJFuT+Vq2X2o6CprLC08tHNEm5
         rVQ4dQotv8GRU9v6r1/67yrDgG57RY1TV8SLpTZANeNGgyjT4Cjlw5Qk+rBmL7vwty
         LEwkJUsRGppyhaTGEhNwChm6aVR5oBSQs9d1TXzs=
Date:   Thu, 03 Sep 2020 21:28:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        lkp@intel.com, dan.j.williams@intel.com, joao.m.martins@oracle.com
Subject:  +
 =?us-ascii?Q?acpi-hmat-refactor-hmat=5Fregister=5Ftarget=5Fdevice-to-hm?=
 =?us-ascii?Q?em=5Fregister=5Fdevice-fix.patch?= added to -mm tree
Message-ID: <20200904042802.YNhn3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: CONFIG_DEV_DAX_HMEM_DEVICES should depend on CONFIG_DAX=y
has been added to the -mm tree.  Its filename is
     acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch

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
Subject: device-dax: CONFIG_DEV_DAX_HMEM_DEVICES should depend on CONFIG_DAX=y

HMAT requires hmem_register_device() which is now placed under
drivers/dax.  ACPI_HMAT is a bool and built-in, and to use
hmem_register_device() CONFIG_DAX also needs to be builtin.

Link: https://lkml.kernel.org/r/8f34727f-ec2d-9395-cb18-969ec8a5d0d4@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/Kconfig~acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix
+++ a/drivers/dax/Kconfig
@@ -49,7 +49,7 @@ config DEV_DAX_HMEM
 	  Say M if unsure.
 
 config DEV_DAX_HMEM_DEVICES
-	depends on DEV_DAX_HMEM
+	depends on DEV_DAX_HMEM && DAX=y
 	def_bool y
 
 config DEV_DAX_KMEM
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

