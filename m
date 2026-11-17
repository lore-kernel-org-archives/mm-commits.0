Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904108;
	b=p7WBtkSOfA1c8BaeZZER1OT+e8weZEsbR2a4hurDYDgY93hnBBCyjRjHjucepGN8yUXr
	 SwRIY72XJUSTBQ726Qg+cJy9uZvOBeCiLN8QZ2Ed/FNaOL+tx1u+UC/7ONE6IMCqdSMHs
	 1CT+4L+YiHEO6V2LlijHH3uHxlEiomhZ5+8330z2SEmrQ+aohmibDeRussx/w1DjV8IvR
	 qoTiw1POTk7o04fc9a8JD0bUsbpBIjwy6ZjlKSLZyVVrVksI0UvCO2lGWRpKyllum42rH
	 BdF9JuUtqWGW2qfyPKHWocguv1q50YTj4V+xMuMwLgeom9WJrtabC4AjK5Fhg9+wVQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904108;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=q+SZ9dGKuptAMh+kM0CS0iPDaEnB618tM58CMDcmKpQ=;
	b=ZIIv4dLVOMD78QEjHBDGgDmrtyMCvr0ac6PPNsAXQQs8WXHf7LtEQpewzUvwa39sGB8S
	 clwrlMrDFFpBMQ8hlQbivK7SdQyvzsMoknwWP33BmTPHfHinnz4K6VdewNdz0Qwq/BMFJ
	 b9P4B4JgSONxMMYgUCAXaAfwsIhnCSnX6aIdUvJKzBzaJ0usAIR2+inakxQeE7su9Nzr4
	 CgqxMtW9WOyWD475SuAdRMV3OuBrPvfB9k67vNUlJppgPODfN0F+dXVjfMfEdT/EHUlEr
	 9fwjVLXzEqwJEJs0/nADeWdYpBFaOm00A2RXcBo50tIiaVnBeC1osxQK7F/KxKAh0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QeMq/403";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE8606A323
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QeMq/403
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D861E1F000C4;
	Tue, 17 Nov 2026 08:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794904108;
	bh=q+SZ9dGKuptAMh+kM0CS0iPDaEnB618tM58CMDcmKpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QeMq/403f0HKu6mxdL1+pDpj231cUgYw3eOu8FYmFs8n6v7nuVSRUNaRdhwA8TCJo
	 DiUR/uD+EfmPC3u1qAy78h/ZXn6shLI6zlFsxYZxWkpnX2r7c0e3l8lN9cwAsRCeZN
	 YTsOrwKVmmD687RFT1nSEe3AKtBkEPW8mRN+YNVIEp0hFPp4h60mQSxpR+bcui5Hmx
	 JH5W1ORyli1g65GjJkEPCF+AYA/ij+ZPoh70Loj1xsuieNirz/NCAUxfMYdAqDtZ59
	 KR/Kk5pKeKkamtPg/DckolRtbfiH+oeWN4lEFLbRx1oBnQZ4x7Eitaa4nN+EXsvjV6
	 nQVBmv9/mPeYQ==
Date: Tue, 17 Nov 2026 09:28:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Bradley Morgan <bradley.morgan@linux.dev>
Cc: mm-commits@vger.kernel.org, yang_yongxin123@163.com, 
	broonie@kernel.org, yangyongxin@kylinos.cn
Subject: Re: [obsolete]
 perf-profile-report-failure-to-create-proc-profile.patch removed from -mm
 tree
Message-ID: <20261117-wolldecke-hautzellen-gesiegt-c8f0ed40a87d@brauner>
References: <20261116164224.AA8ED1F000C4@smtp.kernel.org>
 <F0C47A12-7949-456F-8E54-F248C585FC60@linux.dev>
 <20261116090305.dd8b867aed47835ce51aa891@linux-foundation.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116090305.dd8b867aed47835ce51aa891@linux-foundation.org>

On Mon, Nov 16, 2026 at 09:03:05AM -0800, Andrew Morton wrote:
> Christian wrote basically the same patch on the same day!

So that's all in -next for a bit.
Ideally I'm going to grab the two read_profile() patches otherwise we'll
have pointless merge conflicts with the rework of procfs that's sitting
in -next.

The procfs rework in vfs-7.5.procfs gives /proc/profile its own
file_operations and read_profile() becomes ->read_iter().

So I'd appreciate if you could please drop them.
