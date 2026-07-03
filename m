Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7063CCFC4
	for <mm-commits@vger.kernel.org>; Fri,  3 Jul 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783092403; cv=none; b=RbWZIiGJDTJW4G14UovNUdO819FJwlxqRm4VnBT0roukTIlTPUd2aFf3CVlAPqD8nTnPkHOaYq0SLL5tJ0a5ddWu9faSnkxn8PFXbVL92MfQOVTESb4c3xVo2sNrdm1FIK+EiqEGeTkBrY4nCY7B9RNWQAkRStDWzb/PoCecmZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783092403; c=relaxed/simple;
	bh=wSbfJ7eR/fmblb4zEWsgMJbri1Ew8cU7BNrLEFB2VJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfwxTbVJVPgApB9yImwdbXeFxy78CyxFGRrULaSNpiAhIa6+vsVp1w1kvpbndROJPJtTlvl6djv8CjEHXaRXRcsmNRC3Vf8ADavQf7vIkc4WOAdUfGIJ9lROPIyxPMQ5iK3hSYDXoaybiFHzsXiTu4urkDIn1mSbie0Mr1dZWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=mLJYny9t; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="mLJYny9t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bv65lkPzk1XARnPumgoWpvuWvZOUdtObeuqcEkVUpyU=; b=mLJYny9tHo4zljuBtl1hQ5eEOj
	M+m2BxHmwg16sKgZKX1bHgyxWDpebBpFA4+q5z4pdFcuxxm2TBYJLY8yo5DAQamr8lvS59Piuo+bO
	4aSzwscK7lnQjhUtEDPNwYYbLy+YaMGIMYvCLXfolNCM875C0Ri7W9fY30ja22PYllfORAAokEGdd
	SpbMGbjDAnRLKNlahbHm8T9ijwhdRyqu0H8V4t4TM73Wu+la0YVyzaZM7NB2SxPEcw94gUYeqA0T4
	GazUB7XbvZKhL/ADInI2FpUCut51KKcFCld0XSiuTXJIoVete3orZ6paa0OhMbLsT1dWHmLxO8A+n
	9q7e+jKg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wffmq-009UfU-0g;
	Fri, 03 Jul 2026 15:26:40 +0000
Date: Fri, 3 Jul 2026 08:26:36 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, kent.overstreet@linux.dev, 
	catalin.marinas@arm.com, bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akfURcWhEWLDjND3@gmail.com>
References: <20260702224211.8EE791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702224211.8EE791F000E9@smtp.kernel.org>
X-Debian-User: leitao

On Thu, Jul 02, 2026 at 03:42:11PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: radix-tree: fix kmemleak false positives on tree head reassignment
> has been added to the -mm mm-new branch.  Its filename is
>      radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

Andrew, would you mind replacing it by v2?

V1 didn't have included kmemleak transient function in userspace headers
(tools/testing/shared/linux/kmemleak.h), thus, userspace test were
failing, as reported by:

	https://lore.kernel.org/all/202607031019.AffpLUyg-lkp@intel.com/

V2 was already sent to the list:

	https://lore.kernel.org/all/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org/

Thanks and sorry for the noise,
--breno
