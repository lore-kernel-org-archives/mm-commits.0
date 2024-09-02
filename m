Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645F0144D0A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248813; cv=none; b=OhxRtZNhcvMzeAYEZoc8L5mCOkvb3ll78Kf6K4aCDxGI6RTeVBIa9VR8y7GvwICX+tzIBguSMIhQ/rRujHnTq9XNPRotIZRrInitaUrAKeoLMJZ5GxR+A9fH2LKVL04abLVgQwp5/2NjPRYr6MjmylQm8NZ+8Hf9OYFQ09H5LXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248813; c=relaxed/simple;
	bh=E5VNxaBQcHvofJNnvHlX2QSQriekw7/d5BQpISNCIag=;
	h=Date:To:From:Subject:Message-Id; b=hpEG0rmQDG5rgTEW4aTfBzq25kPDPhYgIByAXCMTkbJt8xBe1NsEkvBtIQKcncr4w9LQ3x/lq4SEtxoWY+RQeofYB0l2ckf66tPQzOqtTLmeDRMkL6ixD6vq9Waieq9RKz5GgXeNx5bZH23BZ/iln0AVEiLdUx8ocobjCAKEm/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovneCrsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovneCrsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE259C4CEC2;
	Mon,  2 Sep 2024 03:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248813;
	bh=E5VNxaBQcHvofJNnvHlX2QSQriekw7/d5BQpISNCIag=;
	h=Date:To:From:Subject:From;
	b=ovneCrsNU+bTUvsRcXvGVf+WuVO6yOJr0f7mP4t2JfNsQhHLCjan+3staWxDRi5OE
	 2u9AkEFBRKCzTGqdI/xpdwfhYAOMHvPp4Ln1b9AYXSDYZExED7u4fIdAbBMcAukb1M
	 FthH8QffcEPmM4SMhVV7RVgiyENjZP4NJOGyfIqs=
Date: Sun, 01 Sep 2024 20:46:52 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bcd-optimize-_bin2bcd-for-improved-performance.patch removed from -mm tree
Message-Id: <20240902034652.DE259C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bcd: optimize _bin2bcd() for improved performance
has been removed from the -mm tree.  Its filename was
     lib-bcd-optimize-_bin2bcd-for-improved-performance.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/bcd: optimize _bin2bcd() for improved performance
Date: Tue, 13 Aug 2024 01:02:29 +0800

The original _bin2bcd() function used / 10 and % 10 operations for
conversion.  Although GCC optimizes these operations and does not generate
division or modulus instructions, the new implementation reduces the
number of mov instructions in the generated code for both x86-64 and ARM
architectures.

This optimization calculates the tens digit using (val * 103) >> 10, which
is accurate for values of 'val' in the range [0, 178].  Given that the
valid input range is [0, 99], this method ensures correctness while
simplifying the generated code.

Link: https://lkml.kernel.org/r/20240812170229.229380-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bcd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/bcd.c~lib-bcd-optimize-_bin2bcd-for-improved-performance
+++ a/lib/bcd.c
@@ -10,6 +10,8 @@ EXPORT_SYMBOL(_bcd2bin);
 
 unsigned char _bin2bcd(unsigned val)
 {
-	return ((val / 10) << 4) + val % 10;
+	const unsigned int t = (val * 103) >> 10;
+
+	return (t << 4) | (val - t * 10);
 }
 EXPORT_SYMBOL(_bin2bcd);
_

Patches currently in -mm which might be from visitorckw@gmail.com are


