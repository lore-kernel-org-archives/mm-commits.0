Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298834FF59
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768346657; cv=none; b=D2y1Z0rSi9uoBoDqMXe/tei+FB9d7Jl/EQatXaokQHMVQ1RaW4d0xDveAQK0rgzYmDLDywClZrUiYYsgd7uczO/q3MIW7DFXbj+VvgaN7ALhx1Tr03lYi55WoUVCYIlIz9Mvjcqe61VWjJosfjMnFVkQ4/q06+IY745qcbTbQwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768346657; c=relaxed/simple;
	bh=CXecMBx+Ev1NuFcdGYfy8RNPnPNU4+kuLz4D9R5dfJ8=;
	h=Date:To:From:Subject:Message-Id; b=b4fEJ2JjcCYrVv3Z2MY9Xv1VmLk5I19R9ySxFyqGbTN/Z6xMVceaUHkiV7pbEsDPc2VkjYsl+advCtKqq3blEhQyfSliXlIj5WSC5aJx6cfe6c/kHJWsC6NzSn6j9FTibv3XWebmyIE+bcehlc2mFCCELiFxKJohptxDumH+dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y+1sftga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y+1sftga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B232FC116C6;
	Tue, 13 Jan 2026 23:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768346656;
	bh=CXecMBx+Ev1NuFcdGYfy8RNPnPNU4+kuLz4D9R5dfJ8=;
	h=Date:To:From:Subject:From;
	b=y+1sftgaZxtbBk7t/HTxBfzKmZYHyUzJ7j1kWuubECcOHwiIRl3hNVneAzkMFMSCU
	 s3IBGxp8qm/xkxShjAt3H/5x5wRXyexgbfMw6By0uTibuJkxCJ2PtURoVik67d7HBG
	 WjGL7vYMjcWDaX+7x1JfXwc8C47kpktohchcPHM8=
Date: Tue, 13 Jan 2026 15:24:16 -0800
To: mm-commits@vger.kernel.org,matttbe@kernel.org,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch removed from -mm tree
Message-Id: <20260113232416.B232FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh update usage to show vmlinux is mandatory
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: scripts/decode_stacktrace.sh update usage to show vmlinux is mandatory
Date: Mon, 12 Jan 2026 17:10:36 +0800

The script currently errors out if vmlinux is not provided, but the
usage string implies it is optional. Remove the square brackets to
correctly indicate that <vmlinux> is a required argument.

Link: https://lkml.kernel.org/r/20260112091057.2119227-1-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory
+++ a/scripts/decode_stacktrace.sh
@@ -6,7 +6,7 @@
 usage() {
 	echo "Usage:"
 	echo "	$0 -r <release>"
-	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
+	echo "	$0 <vmlinux> [<base_path>|auto [<modules_path>]]"
 	echo "	$0 -h"
 }
 
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are


