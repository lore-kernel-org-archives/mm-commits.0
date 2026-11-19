Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795065940;
	b=gZZ8MGPsmaA4WHmWsPryC8IL4+e4FKuLSgSsJ1Pfln1yk++Vz8+SMdmQvWtnRnaOqk3I
	 jtO4D4AcHUHe2OjENSgpliZUh58VKGCg6tB+cVM4/oN4r3hMIxK1xRGeGskx3G1tLu0uH
	 /RwqPg3shXKFGwsgLBm4+qC8f1l40QipVD17BWLjlTEFp919N/FRremc+c7CI1turoZSr
	 5FeNB+QQUNzJB1keXxWfhq8Hjic/k2v3KCShlnk4xItpSy0ZDJR8mxqQ8XYuDKVZKwyOM
	 RdgyWwe195nZPuQDx5C1DMvjytVq89C4RUIY/MMbztcDOsaWF5S0OkVfHG7wjlr7yvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795065940;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LXiVx5mLfIEzf8hjDa0If8oOJDW92Rz35E1HYThx7/0=;
	b=Q91jGYJX1DA94SGiGA3Z60vVcyKsk8r0V/EHrKEOsvJQEOq5FNgijEFr5FSMllmsKVNI
	 ARCkbWHpQ4BUBLhNZV/DjoWcwvuTa4spm+OADviEnRfOdoZvAip80B+bwa+lVGNa+WCK9
	 Xu0J0RKaNSGsg11/d1gyDwXTObo6vJhqlpeH/U0C7FHBka86/UXdt8sDyBuvBir4hIMdj
	 mutCxCLzdOyw/0Vkgsz923sxIwvM7iQo7MYCLqa+pZLbK8qrXuseEKVP8ZCdQAZRiMIkE
	 9IVeKxI+JHWBGoj9x+OlOyBca1A24wyBuS0qfKz1gqwAPQcvPSbvaLkTIurDONw1djw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aJ6xIdcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6880E606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aJ6xIdcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38B71F000C7;
	Thu, 19 Nov 2026 05:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795065939;
	bh=LXiVx5mLfIEzf8hjDa0If8oOJDW92Rz35E1HYThx7/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aJ6xIdcgedPDRCF/mKWnxOazcpJHvxbcUw5IdV6SzstqdpaM98o6c1KUQ1WY67bgP
	 iNSaLrM2Iu1tiCFmFFGYeFWbuGiRsGtBFF7LN+SGB8ElAd+BGDRhVSXAxljcuht4dC
	 knG/iBv++4lngncXhm4Tk2nRchNsXPG6BadUbrkk=
Date: Wed, 18 Nov 2026 21:25:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-Id: <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
In-Reply-To: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
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

On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Hi Andrew,
> 
> during some chat with Lorenzo, it occured me that it could be useful if your
> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
> the respective patch postings, which would put them next to the patches in
> everyone's inboxes. I think Lorenzo started to doing that on his receive
> side with postprocessing.
> 
> While I haven't checked your scripts, I naively imagine it shouldn't be hard
> to add that In-reply-to: <msgid> header. You already have the msgid for the
> 
> Link: https://lore.kernel.org/<msgid>
> 
> part. Maybe it's tricky when there are more Link:'s than the patch posting
> itself. But actually after Linus initially hated these automatic Link:
> additions, he later settled on the Link: https://patch.msgid.link/ template
> as acceptable to him. It's sort of documented in
> Documentation/process/maintainer-tip.rst too. So changing to use that
> template should allow to easily grab the right msgid to reply to even for
> later actions on the patch, than the initial addition.

np, that should be working now.

I switched it to patch.msgid.link for just the Link: to the original.

Konstantin's
https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
was helpful.

I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
guess it'll be there for a while!
