Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888BC1AAA0F
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 23:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733873008; cv=none; b=ED+ybbFNz4ubWkjWLdQWa2z0W9ShZ2p0flUSvQNGDzGrYvtU4ue3475a2TN+zVivqVb/CMhgWvHdl0Se99BEvUphc9IvKS8v6SPOyQ9ztlwMbN9nABQPO8a4X8OHUaK1IbfYoJ4X+eYb4NlmevAnCyVwCVblyjjwovkHb3uBnw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733873008; c=relaxed/simple;
	bh=lbGc4s3tRNYlC3x8X9hnZTN2hkvZ6QPBUxlPyZ2pI5Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cD9qLb5W68Tgsvr5nfcf5oqnig1Hn6/4vy/SyqxQnUKzYRPq8AWKq0MIoU7h3PaBdmjPsZg9R5FrFSj9hOAj+o2+HTJJbElngtetypaL3auxRaFIlksN/8QexfJeUUp9jOUtIwnw/4AWgjNu0Main7uhSIXguiLO7VC51GGgtR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qmvb0mMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qmvb0mMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F22C4CED6;
	Tue, 10 Dec 2024 23:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733873006;
	bh=lbGc4s3tRNYlC3x8X9hnZTN2hkvZ6QPBUxlPyZ2pI5Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Qmvb0mMNDQb2tzGATTDxoHItpMr4zo5UWl108WZ2orYiwtUWh7KtxfhftptyduFlr
	 rZOaeUTcQbBlneMfr6CPOVoeMjOqfYGfkKK8ym4Z+iLVLBS2YvgXaVD9f48rKOHi+/
	 uMPLDSTDM5Cj9UdU2G6825lgUAzIzIHtxd+CQGfQ=
Date: Tue, 10 Dec 2024 15:23:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
 david@redhat.com
Subject: Re: +
 mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
 added to mm-unstable branch
Message-Id: <20241210152325.dfe565653bd8f715731a75ef@linux-foundation.org>
In-Reply-To: <db5386c99676aad0fb3013536a492554@suse.de>
References: <20241210014748.A16A2C4CED1@smtp.kernel.org>
	<db5386c99676aad0fb3013536a492554@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 15:21:54 +0100 Oscar Salvador <osalvador@suse.de> wrote:

> Same here:
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Yup, I had both.  Often these things get filled in later!
