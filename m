Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAE7145347
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293203; cv=none; b=bq77UmL7MYU530DZkzV+KarxD3rRFN6WAh2KpPUP73htAhmhCQi7RjpV/bgX6OEtUHlwf9e92ezei9oy9tJ/w+Fi2dRVQW9/3PQrIluauzmPhSL9GCIzEQFZ/XTbo7W+tFoWq1qSmILExTFf2TwzOOKgPyf6Hv7AxTvBEbXJDr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293203; c=relaxed/simple;
	bh=/gCnZDyvACPAJYUyzcCYJAqU84a2oiZgfkD75leooOQ=;
	h=Date:To:From:Subject:Message-Id; b=t/IW4/lBeWuleL4pMDc4KDHAj9sWYwSwc2ID9JrhIz2jnvBDWzmpGfGlbY1ug51A04dBjitWV/HJ2Df01hGy43MKULvOr67yAAIHNwtuFNA/2Df4EVuf8U/NVCzGvGJ8mtcFhY66bXyuFcXBksZLHBuxNDy7d8P+GaNSoIUFKT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vlSHLgeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vlSHLgeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0225C32782;
	Tue, 25 Jun 2024 05:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293203;
	bh=/gCnZDyvACPAJYUyzcCYJAqU84a2oiZgfkD75leooOQ=;
	h=Date:To:From:Subject:From;
	b=vlSHLgeB1bnBuuAmDyTKE9W+4OJa7qwrRUMDM6I5thmPxeZEzCQUcZzerpqETyx9/
	 o3gXVkEnNtxp1HJrf+d8h7VPnJfMfQ7c+t5hdmL5Ku1j8bJa690TqJska84b1iIKJS
	 PYg/uT3Xx+pwDASg7Q+YSj5jKcSHFOHs/mu8t5UU=
Date: Mon, 24 Jun 2024 22:26:43 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-asn1_encoder-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625052643.B0225C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/asn1_encoder: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-asn1_encoder-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib/asn1_encoder: add missing MODULE_DESCRIPTION() macro
Date: Sat, 1 Jun 2024 16:09:47 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/asn1_encoder.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-lib-asn1_encoder-v1-1-8c634ed2d2e8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/asn1_encoder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/asn1_encoder.c~lib-asn1_encoder-add-missing-module_description-macro
+++ a/lib/asn1_encoder.c
@@ -449,4 +449,5 @@ asn1_encode_boolean(unsigned char *data,
 }
 EXPORT_SYMBOL_GPL(asn1_encode_boolean);
 
+MODULE_DESCRIPTION("Simple encoder primitives for ASN.1 BER/DER/CER");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

