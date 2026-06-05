Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32A282F0E
	for <mm-commits@vger.kernel.org>; Fri,  5 Jun 2026 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648877; cv=none; b=jZUU6XyBsTreBKTrGlFYIUq7sP4G5qd7mvYtNazu3029kirt6bhlYCCjfQ89yV40brBKiTOHdvB6POhaLMMEOKZaXb4md4OSPBHgF9zBu+e2ueAjvTQ8U36KNNSvQHxi59/Qn4c3a6St34R+87QpWHQsIbZXhKDYI/gBj4tGQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648877; c=relaxed/simple;
	bh=NEiwu30T8AVHm1dAZ/9pGCqXy0YodrOuj7n49OSAJQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXK5ZKv3g1sOwCqDtTyGJEellYhWT4M9qixFwC10kg555UtYCEovzEtofXsmTZLIdgfw6AnA6FSdpuFYza4pzJurmQxOokd2jKjn1A/Uz7+JQnGTmRZHrm2+6t3TLTm+hxQeEumo5J0JNbx2hd3oh2VXgd3qdk9pGUqkFYzmL1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CH5/Arhw; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CH5/Arhw"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36b8d414666so1044333a91.3
        for <mm-commits@vger.kernel.org>; Fri, 05 Jun 2026 01:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1780648875; x=1781253675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bLKFkbSU9D/bSEthp0PL0aU6QU/S6aLYxijiwDpkmA=;
        b=CH5/ArhwCGyy+XjyW9804MVHDJjS8UYWFIDkhAdE9UMV8PtInjG2wYVHGUlXpMI/Uc
         tu9gOG13/UkL+SuSF3necfq+Tou8S4vYaijsI0KYvHyKYrcrCKc92ER8aGxJQdfoIYjr
         JTLGCD+UcGfZH3Xe+0D30pcGKeW/cQgmS/yuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648875; x=1781253675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bLKFkbSU9D/bSEthp0PL0aU6QU/S6aLYxijiwDpkmA=;
        b=hLGIeLz7yyt9UZj0FAHfdT3L9eMr+j/u6v9elyqnGjYWwIhHxrWAXM8KSoHZuZkDKo
         EEbUWSXPpH7A4fhqDFFfptw60JG5RP0tykv/bXsbXIFZ6FKQcKqI/40BcBAwC5VHSvY+
         0aw2n4RqSo9N+7c7eY+KthsTqlzsrqlBADnO8gpvjvDUF3J1055hWWduuxlmv4xel6no
         kkTv6dfzJI+0OnhSRYbq/KqwjFv9ETvwJvNKqZqtWj1xGNnf8LQa6wf0jZCxACMzReoH
         C4dVJRR7BK4j/2vdMnFAfLTW/wDOAsejdrB3HHcSs+5q6Tvv6HtCV0uQlWdItRbzo7PC
         kD5A==
X-Gm-Message-State: AOJu0Ywp1fFakdhlCqkDIRjY57T5PR+JyppKGhDsjMvds28WWWx/ky64
	r2dSSaE7CexONqiMHAT/CsepBibJK4Y56Vm9+CRDNVnrpOrtysRehzPRaKajcEREQhrbfE88o/n
	uNsY=
X-Gm-Gg: Acq92OEEJjBJy8M74clgQJHUUK1Z9k0oe254vIRMw/fqjAryHWQmcQLL6aNsKMQ5Nk7
	lh0M2IDsC0RFK1bu+t3WErfssAKJZOO3leZ7P+qGsCyFTp0/faPoncBwTDJkLSu0HJZQCFThs19
	3gaGPaRzXWyF0m4IDKO+TbJ8j2Ot7zllSHxNGoeSuKvvax6FI729aIrYnYF8u8FKu17LXLUygZR
	pyh7VGt6TA14So/5AU9LBSoXe9l+7ppLyHsa6Sr1lVy3UvaKAoAonVP4nHsIpw0XnBsRWBb4I6z
	zkQGnIE48m94MdLH7x9+tp4ZeyDi2dLMrLhsWaPVIEqxIF6qMSPB0k8Tea7R7VsdC8Y3GKAQq2/
	k0eE/kkJELt0fPSK7fEAc4+nHhY8cc4L9nn4ROQKjZmJf8IwJ3EqyPUxzGTtyOjWdWrH7NZb+kr
	4dY7SGmO6tVFcphrBWKorRWlfAyllglFrfhMTv2Clsavhvqq6e4yYkScJRETZn2rtT/KNs7GLo4
	g==
X-Received: by 2002:a17:90a:fc45:b0:36d:a510:f8eb with SMTP id 98e67ed59e1d1-370eeff1e46mr2626682a91.3.1780648875297;
        Fri, 05 Jun 2026 01:41:15 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:31ee:b5b3:5314:f49d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c6751dfsm5892492a91.8.2026.06.05.01.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:41:14 -0700 (PDT)
Date: Fri, 5 Jun 2026 17:41:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org, 
	minchan@kernel.org, elfring@users.sourceforge.net
Subject: Re: + zsmalloc-simplify-data-output-in-zs_stats_size_show.patch
 added to mm-unstable branch
Message-ID: <aiKLUlxmicjt4e2b@google.com>
References: <20260604172648.27B151F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604172648.27B151F00893@smtp.kernel.org>

On (26/06/04 10:26), Andrew Morton wrote:
> The patch titled
>      Subject: zsmalloc: simplify data output in zs_stats_size_show()
> has been added to the -mm mm-unstable branch.  Its filename is
>      zsmalloc-simplify-data-output-in-zs_stats_size_show.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-simplify-data-output-in-zs_stats_size_show.patch
[..]
> ------------------------------------------------------
> From: Markus Elfring <elfring@users.sourceforge.net>
> Subject: zsmalloc: simplify data output in zs_stats_size_show()
> Date: Thu, 4 Jun 2026 10:20:03 +0200
> 
> Move the specification for a line break from a seq_puts() call to a
> seq_printf() call.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Link: https://lore.kernel.org/126a924b-6f68-43bf-ae5a-449fb93e527b@web.de
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
