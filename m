Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560640;
	b=VNdd9b5RZU3jVNst3cFj18kQfYAyXaKfjCfYEL/6+fJ/EmYQtg/ErfmBpYUUIN8vnpnX
	 Dkl0odD9w5IpBhs3yXNXiTsIVGyRokJW5ZazCWGZTH4uL8Jrh4PcLzKBqReIJBVcRHlnF
	 KN9Ilew7Ewga8feuPFFKZOC/VLNBaDWK6Tn/nUxGBhqlZIwuvOy3TCvH2d2lW9Q6MdwhD
	 Nb5dFTIH3OpElxNJvaGGMK6qK2rc2pclk5pfCr1I4kWb/9vlmSULdME5sFw9LaPLmnzrv
	 PEBzpYhpX7d3igTNSqzvE4Mh3QQNZ2/YdSxGh0aH3sNToioNnwQj849jSePkxuT5NIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560640;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J3njOg1oScoF1+bUW3A8odaJdb6GOfJ3tHhTrPyMj4M=;
	b=zfUto0zNvaRLWNJ7YGTB931lsFGw/MLbQfvKA5/mklcGH+PyX3S9kMczIMF3BrNvdJg4
	 Yng1zcly5C5maGjwCrJtFCDoHOopiw1CVSuPDpIbYs25Hf1lsoDALjN7Z09LE783R5dnz
	 oH5jaa84v27AwDmOqPXsfibMf+8MHwOo3rG0zONmLvCv5p9Yeb9hOx5+u3aDGgJwZ6fly
	 2qhbkqGVsCS7CV45Tx4JPU3BEFryJ2BMxR0L79tvV6h9QyrNXSINwtCf60D6nLQCwOF7U
	 pKOlP49fCFy4h08MsisyBBL6iFCbZjRnZiZYsLaDJJZI8Ej578s3cJTyGhUU2AcnrHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QqVirBkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797DB606A326
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QqVirBkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431191F000CA;
	Wed, 21 Oct 2026 05:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560640;
	bh=J3njOg1oScoF1+bUW3A8odaJdb6GOfJ3tHhTrPyMj4M=;
	h=Date:To:From:Subject;
	b=QqVirBkqJ6DzQBHm2/Z0w3jGWB5yWqqjRgAdpcQJg2NTGA31huftuyA1dhnGGqtFy
	 MUW8nb0VIHYzmpmh9lzXdJRLOo+Sn95to8/m6Lj+K93tY240lQHai1eRjkWx4euFcD
	 cURHQOEaINyA4prphnsd9TlQaBzi4I6oZYYpoVqA=
Date: Tue, 20 Oct 2026 22:30:39 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,blum@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch removed from -mm tree
Message-Id: <20261021053040.431191F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib: kstrtox: use isdigit() in _parse_integer_limit()
has been removed from the -mm tree.  Its filename was
     lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: lib: kstrtox: use isdigit() in _parse_integer_limit()
Date: Tue, 13 Oct 2026 09:21:10 +0200

Use isdigit() to replace the open-coded implementation.

Link: https://lore.kernel.org/20261013072108.4407-3-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~lib-kstrtox-use-isdigit-in-_parse_integer_limit
+++ a/lib/kstrtox.c
@@ -69,7 +69,7 @@ unsigned int _parse_integer_limit(const
 		unsigned int lc = _tolower(c);
 		unsigned int val;
 
-		if ('0' <= c && c <= '9')
+		if (isdigit(c))
 			val = c - '0';
 		else if ('a' <= lc && lc <= 'f')
 			val = lc - 'a' + 10;
_

Patches currently in -mm which might be from blum@kernel.org are


