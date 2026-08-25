Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5710825B098
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622325; cv=none; b=QIeXzMLB149f+9AIcWNoQAfjWBiEBN6rMNuavhcVm1ANPAOrSS3CwDY7K+58AaqcS5HHgX1GlcaD8lzu3T8PLvtigVgyOQ15+mLY/kpsNl9AZr3ytIarC+Tifmj7Q/OplpjBJ632cuTsDtcB00MFUclkS7fQxBUOLWPCxPXm9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622325; c=relaxed/simple;
	bh=wyuhZY2XVo0Q9lchEXvfnh8pDDYfwihr/Uc40EdRcRM=;
	h=Date:To:From:Subject:Message-Id; b=cwq2klMaSRr3FiMttRJo8F4iYOP05S8IpDcf9g1lWI/odnQDF+hEqd6gMOrzHcRzscMPV4iGoBkXHlFlmO01vZlA8Sh4maERBJDI4t6t8OYczXYaVq3CdBXem3N7Q45b5RtZNX0L5BRRmIZUw7VmGPxIhoPopv7RtPqXfdlk5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdrcaVWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdrcaVWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4501F00A3A;
	Tue, 25 Aug 2026 01:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622323;
	bh=7A8c1M6TBPOLtk4CBvtZRpjl/M6bWZbL5C3b/WRbaVU=;
	h=Date:To:From:Subject;
	b=OdrcaVWb3p+9LS101122RbJOAWEquUMvHM6FdLc/Q4m3woi57BnbJHrPRfy+L0bOj
	 K/Chs2b2rI6xgPs4dffCEZ22iveNstuu7MVWbwxT6JIl81nNTPgEJidqjoA9waxj42
	 Eo6L9oIPMB54PMmSudFP/LEKQbxw65M1eLlg9yns=
Date: Mon, 24 Aug 2026 18:45:22 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,corbet@lwn.net,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-zram-correct-algo-parameters-configuration-documentation.patch removed from -mm tree
Message-Id: <20260825014523.2B4501F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: zram: correct algo parameters configuration documentation
has been removed from the -mm tree.  Its filename was
     documentation-zram-correct-algo-parameters-configuration-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation: zram: correct algo parameters configuration documentation
Date: Thu, 30 Jul 2026 16:51:46 +0900

zram has always reset all previously set parameters for the given
algorithm in comp_params_store().  Make documentation more clear and
explicitly state that all relevant/necessary parameters should be set in
one configuration write.

Link: https://lore.kernel.org/20260730075158.1339787-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   34 +++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-correct-algo-parameters-configuration-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -109,14 +109,41 @@ path to the `dict` along with other para
 	#pass path to pre-trained zstd dictionary
 	echo "algo=zstd dict=/etc/dictionary" > /sys/block/zram0/algorithm_params
 
+	#pass path to pre-trained zstd dictionary and compression level
+	echo "algo=zstd level=8 dict=/etc/dictionary" > \
+		/sys/block/zram0/algorithm_params
+
 	#same, but using algorithm priority
+	echo "algo=zstd priority=1" > /sys/block/zram0/recomp_algorithm
 	echo "priority=1 dict=/etc/dictionary" > \
 		/sys/block/zram0/algorithm_params
 
-	#pass path to pre-trained zstd dictionary and compression level
+Each write to `algorithm_params` replaces the entire set of parameters of
+the corresponding algorithm, parameters that are not listed in the write
+are reset to their default values.  Configure all of the parameters of an
+algorithm in one write::
+
+	#WRONG: the second write resets level back to its default value
+	echo "algo=zstd level=8" > /sys/block/zram0/algorithm_params
+	echo "algo=zstd dict=/etc/dictionary" > /sys/block/zram0/algorithm_params
+
+	#RIGHT
 	echo "algo=zstd level=8 dict=/etc/dictionary" > \
 		/sys/block/zram0/algorithm_params
 
+Select the compression algorithm before configuring its parameters.  The
+parameters of one algorithm are not necessarily valid for another one, so
+changing the algorithm of a particular priority resets that priority's
+parameters::
+
+	#WRONG: comp_algorithm write resets the previously configured level
+	echo "level=8" > /sys/block/zram0/algorithm_params
+	echo zstd > /sys/block/zram0/comp_algorithm
+
+	#RIGHT
+	echo zstd > /sys/block/zram0/comp_algorithm
+	echo "algo=zstd level=8" > /sys/block/zram0/algorithm_params
+
 Parameters are algorithm specific: not all algorithms support pre-trained
 dictionaries, not all algorithms support `level`. Furthermore, for certain
 algorithms `level` controls the compression level (the higher the value the
@@ -124,6 +151,11 @@ better the compression ratio, it even ca
 algorithms), for other algorithms `level` is acceleration level (the higher
 the value the lower the compression ratio).
 
+Parameters are handed over to the compression algorithm when the device is
+initialised, hence invalid parameters (or parameters that the selected
+algorithm does not support) are reported by the `disksize` write, and not
+by the `algorithm_params` write that has configured them.
+
 Set Disksize
 ============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


