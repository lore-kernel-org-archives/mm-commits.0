Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848587;
	b=iknn+7PK9I3H2d6AR5n1x0YYrHXdbzCw9Znnz7xpfG/is8lVtxFTYwTf7TNfWBGpoDZC
	 EkHiKtvw+BJPslM511xRjkXPtF19gpRyniBNvwisbKHb5ynsYn/jPuZOUT3IrFMgdeS+j
	 sLW2Rz1R27FO2sMJJ5PLeKUBk2PNkwM3tXvMeDLbt/rKsh/nhe0RwsDrqlCYm7mKHi7ln
	 KRJcQaLwPcAz+Trv4INtX4AOxqCAV0fnE2ujb7ox/3gOyDduay0AAk/Gm3yhWpG3ezRHs
	 fv4Tsts1KpsZI2zj5aRabA2J7Vfv0WeY9u4fagAGGKhhh9hygk0N7x1eBsk0/RTgWwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848587;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ENqbabp1DQYLpG1003Ym7IbxVgIBzYwCJn5M+Mpauck=;
	b=1MdgEgD2Ust0WJg67oKCKis+AQXsmzpMdIDTPjpbY3K8IYe/WIPyxNiHpYquTHnn9u3Q
	 xbtecEf8fn0McGLGMMRL8VLqtR+K+60NmJ/GxSNwQb/WxBitFO5Beyj349gGuZbpf2i5s
	 IZpE1NG5CLtfQYcT/JPqU8JaPaUH/keydzXjx587KbSGBpp8XP+aXmadp60l9dqKuVjiR
	 7Pso4Gj/FGIQYrXGTi7CexZFT3nKciqp8zFl6znKOiQuhW86fc6P6q2I5TL+nomAQBr5K
	 I7EuFKjLVb6JNVUNB28m1GTLCtBQmYGcp5h71W/Fia+PYhO4ZPpkpo2xo8ax4FImM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GEaEsbzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EF8606A8A0
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GEaEsbzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CB11F000CA;
	Mon, 16 Nov 2026 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794848586;
	bh=ENqbabp1DQYLpG1003Ym7IbxVgIBzYwCJn5M+Mpauck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GEaEsbzI2/RDtWGK+8swic+CP4I5kqxWW8AX60mN5XZfaZBbrrht0RN8/eFd4fyTA
	 8u5ZAimsKObfhPDqYXoflzI2fxCHsERqoIZXOJ/MnA8yRAsbmKiclaKpRu+R4puEGu
	 SpJGwaicreB67+n2x6TEpg4u7/Q3ppUENhSjzK/A=
Date: Mon, 16 Nov 2026 09:03:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Morgan <bradley.morgan@linux.dev>
Cc: mm-commits@vger.kernel.org, yang_yongxin123@163.com, broonie@kernel.org,
 brauner@kernel.org, yangyongxin@kylinos.cn
Subject: Re: [obsolete]
 perf-profile-report-failure-to-create-proc-profile.patch removed from -mm
 tree
Message-Id: <20261116090305.dd8b867aed47835ce51aa891@linux-foundation.org>
In-Reply-To: <F0C47A12-7949-456F-8E54-F248C585FC60@linux.dev>
References: <20261116164224.AA8ED1F000C4@smtp.kernel.org>
	<F0C47A12-7949-456F-8E54-F248C585FC60@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Nov 2026 16:55:58 +0000 Bradley Morgan <bradley.morgan@linux.dev> wrote:

> On 16 November 2026 16:42:24 GMT, Andrew Morton <akpm@linux-foundation.org>
> wrote:
> >
> >The quilt patch titled
> >     Subject: perf/profile: report failure to create /proc/profile
> >has been removed from the -mm tree.  Its filename was
> >     perf-profile-report-failure-to-create-proc-profile.patch
> >
> >This patch was dropped because it is obsolete
> 
> Huh?

Christian wrote basically the same patch on the same day!

https://lore.kernel.org/avsnCFn0jCvbhtRw@sirena.org.uk
