Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48E9C54F4B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2941825429
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599242733;
	bh=Nd/3VI4OvoFXyILB+dVfOyQuYKChqxLl9Gynao03GD0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yinoHVrRMx5lNMrp7zNM/53rKCXEHdWncf9TbC9/yWXuNkFFTmbo3nNPkCX/wWmUC
	 NmySImgECklWg4rB52CcuAbuRzLjg8tBTG4zlU2G8LOmmEhptuizAIG3ZucKcsS2bq
	 i05JryVV+Sg9N6xT8hg8rr9k/vv+Fn0EPuBaawDk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgIDSF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgIDSF3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:05:29 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD1B21789;
        Fri,  4 Sep 2020 17:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599241694;
        bh=Nd/3VI4OvoFXyILB+dVfOyQuYKChqxLl9Gynao03GD0=;
        h=Date:From:To:Subject:From;
        b=WA7etoQTIazG9COR0KbQDaezPiO70A3ek2jZrlCVs1kyXdZJ9ntHBJJv2li5ES/wi
         wIBQxVGPcUYi1DDosWj6uHpldxdQl8YMh/jzGu+dRO4cfKGntczgmhhT7KKdGjwDjH
         kX1hjTk3gWwEPuXG0fvoN/BELxkE2tC1bPypyeyU=
Date:   Fri, 04 Sep 2020 10:48:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, oberpar@linux.ibm.com,
        colin.king@canonical.com, leonro@nvidia.com
Subject:  + gcov-disable-gcov-build-with-gcc-10.patch added to -mm
 tree
Message-ID: <20200904174810.WRC2l%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: disable gcov build with GCC 10
has been added to the -mm tree.  Its filename is
     gcov-disable-gcov-build-with-gcc-10.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-disable-gcov-build-with-gcc-10.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-disable-gcov-build-with-gcc-10.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leon Romanovsky <leonro@nvidia.com>
Subject: gcov: disable gcov build with GCC 10

GCOV built with GCC 10 doesn't initialize n_function variable.  This
produces different kernel panics as was seen by Colin in Ubuntu [1] and me
in FC 32 [2].

As a workaround, let's disable GCOV build for broken GCC 10 version.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1891288
[2] https://lore.kernel.org/lkml/20200827133932.3338519-1-leon@kernel.org
Link: https://lkml.kernel.org/r/20200904155808.4997-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/gcov/Kconfig~gcov-disable-gcov-build-with-gcc-10
+++ a/kernel/gcov/Kconfig
@@ -4,6 +4,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
+	depends on !CC_IS_GCC || GCC_VERSION < 100000
 	select CONSTRUCTORS if !UML
 	default n
 	help
_

Patches currently in -mm which might be from leonro@nvidia.com are

gcov-disable-gcov-build-with-gcc-10.patch

