Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B83246ED
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246574; cv=none; b=IehY+Jw4KfyQyXRWhM/zBsc16jREvMcO3nbnVmjqn/I6sAKz3stD99wLB6pxFER0NZ0ncE/LpP545C3BazgwNJJ9BeRlAi9XXssiskPcmK9cJTJmC0Oq/IJ8MCPBMgiy14KTYE0TYbX9JxGLg22GxmPh5cAjPCjWYhgP2+o8UGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246574; c=relaxed/simple;
	bh=mkuzxvN5o/kxXZgn62IZlIIUbhSWh9Yz1h9I/ObMi3k=;
	h=Date:To:From:Subject:Message-Id; b=l4hacUlDP8DX0GFN7ZmJrArZqP99ORRErUC4S1FG0K+qYCx0zHzkR+84+O108GyZ9U/7W3BSHmfHcAB4cwSqhh70RpEGsJwRfxemE8wldLGYGpDf8fmXM6p4qxHvfyRfwYXXNXAVGmwzg7l3ncW7KP9EJ2SfSg3xSennzi5lWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r6Lb+Dsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r6Lb+Dsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E33C116D0;
	Mon, 12 Jan 2026 19:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768246573;
	bh=mkuzxvN5o/kxXZgn62IZlIIUbhSWh9Yz1h9I/ObMi3k=;
	h=Date:To:From:Subject:From;
	b=r6Lb+DslRSMlDNxZCwYZEMn04UG1zP/qlis3d1HioxQPke9UHX3cJtbEJsWBPGKsA
	 KHu3Pcwr+OTJYL75NFwlGI4xYKxU8vfrHkDcwQJjkpIndSCz4yPcSEVLReP+8UgJvc
	 abXD7xI99Wwqz+uwmV6FOlHusIO9uRkYfND41Fes=
Date: Mon, 12 Jan 2026 11:36:13 -0800
To: mm-commits@vger.kernel.org,matttbe@kernel.org,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch added to mm-nonmm-unstable branch
Message-Id: <20260112193613.A5E33C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh update usage to show vmlinux is mandatory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

scripts-decode_stacktracesh-update-usage-to-show-vmlinux-is-mandatory.patch

