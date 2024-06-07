Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211126AFA
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717770799; cv=none; b=Ha+k8eioF3GaIqEh74xMtUJJZLXwEXjZppxOUOfLW05pRK4B878zr3x4htwFyAjrRpgsACWF4JkGZg8KFz1MLbbkFiyv4zxwOvssSOY/w276COx6ZrorWZK1+QkBldsJIQKOStvzSn2zzlYgmYU7J9vbo+3wGV3AeHtQhn4obWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717770799; c=relaxed/simple;
	bh=908YYwZoWx/QDxJtfiZOLEMt0AWyQ2kYI6r0PnW1A2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLApvTmvcZQc6+GY882U3OURxfqUBFAW6VooVP1MaTum7g9YCKUOSTPvQPAIgYSYKv3Lc3LdbCKRMKX60wPa5/bqOZExEoC8lDiDjrotf36SMjFEnx36wIS/g8o2rIXN8ZpRfGCZz26f1ecnPtI9tmafNuXyzgm6OGYwCS1vvCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=J+g5FKtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J+g5FKtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA5DC2BBFC;
	Fri,  7 Jun 2024 14:33:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J+g5FKtW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1717770796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=908YYwZoWx/QDxJtfiZOLEMt0AWyQ2kYI6r0PnW1A2U=;
	b=J+g5FKtWyV+ZPXMKttUgteevHH7NTeBX7oJAswjdNagjcrRSzHWjeRVrh1BUS8Xrxm53Vq
	Ec0Iv2cPos2zWSAwqtaGKMxnfyY1+iOgmMA8A349sKE8Vv/cI5a6uJHGXOp3VpbQzrR0Xu
	noa64FYQyxo6eucTbzBAO+1PAN/ewW4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6de08c9a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 7 Jun 2024 14:33:15 +0000 (UTC)
Date: Fri, 7 Jun 2024 16:33:09 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, quic_jjohnson@quicinc.com
Subject: Re: + siphash-add-missing-module_description-macro.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZmMaJQyBAplQznq9@zx2c4.com>
References: <20240605230857.0241AC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605230857.0241AC2BD11@smtp.kernel.org>

I was going to take this, given that it's my code, but I don't mind if
you do in your tree. Probably quicker that way.

Jason
