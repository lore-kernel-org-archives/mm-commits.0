Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458894;
	b=JfItq5UC4XiUhNcTJvu4BT/xjYkEaluA4zo9ZPHQ/Yz9yy72yw0K47zD2R0jatponiMS
	 aPR8sxnah+sOSFFPsZPfbDElx9crJolGJd+ccSCJKQQb0NrWszSW4OcFYDOLAYRrOVV7l
	 oQAg6VChYJDC2qLWRWXSvzC70bZKuOTqwRHYsfWNYX3uWC/26BtzevdhUeUgy75gJnqgb
	 3/6EnCjjVUH+C6FOuOhAiPW/VpP5871FZJAlcrzYVYYe13fFJwEoyuYvIBdQhwJNwWamP
	 S6qA21+F+IhLH6JhkYPWy+4cYO0fwWp+dHWFXxOFc/zH21aqkXqs2wa0qSixsdAkDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458894;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Gbt4OJAiwywPMAoiP2A8ZUA5wRNzJGa/J32O/0Hj4uk=;
	b=z9U1dA8sqFFLRCw8IRr4pNioSvAlKEGRfwLNVmowNk8qbp0YjN/cVicaSrPGY3Lym4EQ
	 gxO6slqzTAg8NHyQWoCfqQIOmGRN+rJ1UGZk5eNPzE6kBumHFsvK8585vGbt8AUFR8VoV
	 xSJGViuZamRJH+yobbVofgsJUxrpqongoHeu2V7yLs2YW7uDD3ioHxT7ZL5e/rhijnmJ4
	 4V5xLnxCqNaNyZSEBeb4+NZBueDZnXOYATGn4XgM0/Jp5EkHmdN85c7/Sy6TkRWYXQ3bo
	 nfuR6SRo3o1TtnxgfWgsflVi2sT/l7fVt6KcLU2kvHaVBI8Mbm8CMs6RoI0oVeyALdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Gqtd14rf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81351606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Gqtd14rf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C6C1F000E1;
	Mon, 23 Nov 2026 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795458894;
	bh=Gbt4OJAiwywPMAoiP2A8ZUA5wRNzJGa/J32O/0Hj4uk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Gqtd14rfevzvan37gQzyqLRw3eYU0w7g+mqlCKNm3xH7Zc8h2axaQLEv55KufBIVy
	 MTxPTvahFtnhqdKmq6T75KTTJhsC2nql6lBtO6+ZeNJa49Ol1aLXIL7NvpXLz6M6mY
	 Ve+iwIXIP7kX+NNvogJJB+jBobQ1uIGKyWh9z/B8=
Date: Mon, 23 Nov 2026 10:34:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, Ridong Chen
 <chenridong@xiaomi.com>
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Message-Id: <20261123103453.953259f94d3c5a0fae1c50c6@linux-foundation.org>
In-Reply-To: <a2b9c99e-b5d3-428a-9b9f-0761b352dbfd@kernel.org>
References: <a2b9c99e-b5d3-428a-9b9f-0761b352dbfd@kernel.org>
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

On Mon, 23 Nov 2026 18:33:36 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:
> 
>   include/linux/alloc_tag.h
> 
> between the commit:
> 
>   dbbc5a3d50f9 mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT
> 
> from the page_alloc/page_alloc/for-next branch and the commit:
> 
>   2cc623f19566 mm/vmscan: move vmscan tracepoints to a local header
> 
> from the akpm/mm-unstable branch.
> 
> The conflict doesn't make any sense, because we're really touching something very unrelated.
> It's likely a merge config problem on my end.
> 
> I resolved the conflicts manually for now and shall investigate:

Ridong's series "mm/vmscan: move tracepoints to mm/ and add MGLRU
tracepoints" is large and contains a lot of optional code movement.

So I think at this time we should drop it and ask Ridong for a much
smaller and tighter patch[set] which just adds those MGLRU tracepoints.
wdyt?
