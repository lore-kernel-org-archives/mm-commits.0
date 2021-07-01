Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F154C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1899761469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbhGAB6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E567E6141A;
        Thu,  1 Jul 2021 01:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104559;
        bh=Mp9auJLxTLvqReqVizpP+BQ+5Se3sAu4cR3+kbDEe4g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ty6bbMv2TXWVTdmUn7BxiEdV71Nm/i9xEhXzi0EC7Qoq9iq/wgX4b2Dx3ZjObeK7R
         0KYyvYuVBPqSNE/5bLu8r0QDCpANwLQrDRLBZughiUb8Hey0qJOG42BR3ygBVe7Asn
         c2RkMmajb9a9qCc3IqkuYhkobxECuLZ30IatUlAg=
Date:   Wed, 30 Jun 2021 18:55:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 166/192] lib/mpi: fix spelling mistakes
Message-ID: <20210701015558.63PZ7e5h-%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib/mpi: fix spelling mistakes

Fix some spelling mistakes in comments:
flaged ==> flagged
bufer ==> buffer
multipler ==> multiplier
MULTIPLER ==> MULTIPLIER
leaset ==> least
chnage ==> change

Link: https://lkml.kernel.org/r/20210604074401.12198-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mpi.h |    4 ++--
 lib/mpi/longlong.h  |    4 ++--
 lib/mpi/mpicoder.c  |    6 +++---
 lib/mpi/mpiutil.c   |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/mpi.h~lib-mpi-fix-spelling-mistakes
+++ a/include/linux/mpi.h
@@ -200,7 +200,7 @@ struct mpi_ec_ctx {
 	unsigned int nbits;            /* Number of bits.  */
 
 	/* Domain parameters.  Note that they may not all be set and if set
-	 * the MPIs may be flaged as constant.
+	 * the MPIs may be flagged as constant.
 	 */
 	MPI p;         /* Prime specifying the field GF(p).  */
 	MPI a;         /* First coefficient of the Weierstrass equation.  */
@@ -267,7 +267,7 @@ int mpi_ec_curve_point(MPI_POINT point,
 /**
  * mpi_get_size() - returns max size required to store the number
  *
- * @a:	A multi precision integer for which we want to allocate a bufer
+ * @a:	A multi precision integer for which we want to allocate a buffer
  *
  * Return: size required to store the number
  */
--- a/lib/mpi/longlong.h~lib-mpi-fix-spelling-mistakes
+++ a/lib/mpi/longlong.h
@@ -48,8 +48,8 @@
 
 /* Define auxiliary asm macros.
  *
- * 1) umul_ppmm(high_prod, low_prod, multipler, multiplicand) multiplies two
- * UWtype integers MULTIPLER and MULTIPLICAND, and generates a two UWtype
+ * 1) umul_ppmm(high_prod, low_prod, multiplier, multiplicand) multiplies two
+ * UWtype integers MULTIPLIER and MULTIPLICAND, and generates a two UWtype
  * word product in HIGH_PROD and LOW_PROD.
  *
  * 2) __umulsidi3(a,b) multiplies two UWtype integers A and B, and returns a
--- a/lib/mpi/mpicoder.c~lib-mpi-fix-spelling-mistakes
+++ a/lib/mpi/mpicoder.c
@@ -234,11 +234,11 @@ static int count_lzeros(MPI a)
 }
 
 /**
- * mpi_read_buffer() - read MPI to a bufer provided by user (msb first)
+ * mpi_read_buffer() - read MPI to a buffer provided by user (msb first)
  *
  * @a:		a multi precision integer
- * @buf:	bufer to which the output will be written to. Needs to be at
- *		leaset mpi_get_size(a) long.
+ * @buf:	buffer to which the output will be written to. Needs to be at
+ *		least mpi_get_size(a) long.
  * @buf_len:	size of the buf.
  * @nbytes:	receives the actual length of the data written on success and
  *		the data to-be-written on -EOVERFLOW in case buf_len was too
--- a/lib/mpi/mpiutil.c~lib-mpi-fix-spelling-mistakes
+++ a/lib/mpi/mpiutil.c
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(mpi_const);
 /****************
  * Note:  It was a bad idea to use the number of limbs to allocate
  *	  because on a alpha the limbs are large but we normally need
- *	  integers of n bits - So we should chnage this to bits (or bytes).
+ *	  integers of n bits - So we should change this to bits (or bytes).
  *
  *	  But mpi_alloc is used in a lot of places :-)
  */
_
