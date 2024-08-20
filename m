Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50F21862
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132012; cv=none; b=piZ/fE9UMILwNcLsEfHRly5xE87ptwz3P+W/usqMPiMihzti5e1S2AOobxf8/0i0Jpr1Yxz6KQtU4GKufqnLXGM+Rx8qCTcCUlr/EcBT0Gnq4Qnm3gFhzMO8HvNwgGoecbp7jKwK3axZcpMf6XzWJ3HMWGJoT+72ap4+nphp6Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132012; c=relaxed/simple;
	bh=wtOBDrCCYcoPSGEiNvDXS6NTvx1FhJ7UBBsA2ZP/BUY=;
	h=Date:To:From:Subject:Message-Id; b=uq5bbLA1zmwaFtqKcIAbTFGo2voHW0JTlm9onD9AxANFRE9gYKdGaB4SdRQDRV7/oSeVYlO/7JPmfSo37fQCRAYa4hAR+FZopg1pOdQSBD4C4QA53xnWiMTJJ3IY6vkOMVWyuMBDgwD4aBGPIxts5dvA3909QsqxHHPZWw2iGTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjcEOvjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjcEOvjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5951DC4AF09;
	Tue, 20 Aug 2024 05:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724132011;
	bh=wtOBDrCCYcoPSGEiNvDXS6NTvx1FhJ7UBBsA2ZP/BUY=;
	h=Date:To:From:Subject:From;
	b=xjcEOvjA+SI5DlDB2ssMvGsCQDgNi2rgr9ZwjNFM5osgjkEWy4pFn73nSDs7UMsrv
	 2zNW5q3HSDJuLGEJJkfrBSqVX2ZQUz9m8UaEsLN4ZWvIAxNAF7ZEtgWUUaqQvuXbUH
	 8vvuoTnji2mQnd5/+UlDgxd3U605W3Sa1XdzWL6E=
Date: Mon, 19 Aug 2024 22:33:30 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch added to mm-nonmm-unstable branch
Message-Id: <20240820053331.5951DC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ratelimit: convert flags to int to save 8 bytes in size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: ratelimit: convert flags to int to save 8 bytes in size
Date: Sat, 17 Aug 2024 14:37:54 +0200

Only bit 1 is used, making an unsigned long a total overkill.

This brings it from 40 to 32 bytes, which in turn shrinks user_struct from
136 to 128 bytes.  Since the latter is allocated with hwalign, this means
the total usage goes down from 192 to 128 bytes per object.

No functional changes.

Link: https://lkml.kernel.org/r/20240817123754.240924-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ratelimit_types.h~ratelimit-convert-flags-to-int-to-save-8-bytes-in-size
+++ a/include/linux/ratelimit_types.h
@@ -19,8 +19,8 @@ struct ratelimit_state {
 	int		burst;
 	int		printed;
 	int		missed;
+	unsigned int	flags;
 	unsigned long	begin;
-	unsigned long	flags;
 };
 
 #define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
_

Patches currently in -mm which might be from mjguzik@gmail.com are

ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch

