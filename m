Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971933CFC;
	Sat, 11 May 2024 03:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715397405; cv=none; b=JiudZ0I1d/oFmhEP7M7jEfSxMMjKFflryRsMhxP9sz1envBCA/AL2d0roc4ks51Jfo2rx1TH+JCY2zHudE0g0sHLpP6BuuCJzzjjww1iwLgH62ly9cG4d98KN+wUat6h/okp3l8WJQDSNHiitO69yc7T11Xm7gAJcYr0zT7Did4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715397405; c=relaxed/simple;
	bh=1BXT9vTuEvaytkfKIN6MzsxTRNizyIlG33pfoih61aI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oa3XWN/P2gbutrTUXNHeG569HteprUzhl/4g5M01zfJfQkfte8kqmZPuybMSLPzZDMkTsY2Z8O7aav5hq1MQPkbUHaDcMJKcOacgQNMMwsDigtcvMsdmuGcEwtmGGQQ3kKYKpd98v1qOjAtGRJ91e4Mu77zzhErCIMEumIwuGXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWjDuvX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWjDuvX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A075EC113CC;
	Sat, 11 May 2024 03:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715397404;
	bh=1BXT9vTuEvaytkfKIN6MzsxTRNizyIlG33pfoih61aI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pWjDuvX1d8wSDdk68ADsNmAGfVT1jeuQXoLMDPUPM5jyv9uuhFmZ2WOc4R/VneWaA
	 +AZaOf+qoYNV2KHUZ1aJcm7FYOYkmT8L7bkF2IFpJrGrQi0B3+XOng8udzzbGqEPyz
	 eMxPQ7s8Qil9zbUx/LjDBLe19YRp64cwO1xXHimQ=
Date: Fri, 10 May 2024 20:16:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] hotfixes for 6.10
Message-Id: <20240510201644.758feb6938755225fea226da@linux-foundation.org>
In-Reply-To: <CAHk-=wjeV5w3=K_r5+ypeB6_JWKiN7CuiReTn+6BMTyXvXZ2pw@mail.gmail.com>
References: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
	<CAHk-=wjeV5w3=K_r5+ypeB6_JWKiN7CuiReTn+6BMTyXvXZ2pw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 May 2024 14:00:25 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 10 May 2024 at 13:17, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 18 hotfixes, 7 of which are cc:stable.
> 
> I assume the subject line is wrong, and you meant 6.9.
> 

yup, thanks.  I've always had problems with that.
