Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7B929D0E
	for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 21:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745099362; cv=none; b=Yco+myQsPcQiFe45jcuUjXlbqht3wwUz0EYi2V92OBwx8Asbj22aIgsCEV8jthQ6DH1OFC7tooalCZuD9j9cVmkzrF1gTvpAuta4i9R2IngR2gRUNt8MJixMTuoSjjs7B42tBU8Vw2GlIlxuuNr6DzKaqIJLT5g5JEc1x8ImhPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745099362; c=relaxed/simple;
	bh=Hdt/qPmZy5+u/hZWojb5LEeMGVSmAJ3oReSlm5fsgqU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=qx/dU4wT4vqKD4conjqpXUZ886RryI9JdMcKnji5BFun1lxdDsfIP3cf6HB4sm/Di9QKV97YwBwoRu/rvWlt4rbTe+FwPqce5fAgCQ8AnPAQBJnULMyIasXVhQvy0JGOnmuJbYBCOw6Q5fPJmo+1MYiylelQP2pH5aJziiIrgnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SN/lu1Lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SN/lu1Lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E02C4CEE7;
	Sat, 19 Apr 2025 21:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745099362;
	bh=Hdt/qPmZy5+u/hZWojb5LEeMGVSmAJ3oReSlm5fsgqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SN/lu1LtGsLZCH15m2WT5JLqNYSh/+4OX6Ix/3WhKKIcAa2tDSg4xegc8MlTJFjVi
	 28u53PEpeQcX2LLXVmNCtEm01h0SI1QVt/eDr9sn1Hkcdq+sKMwXHhiVl7c0mQ3hw7
	 4LTzbrYxwVVwmgb4KtjD/Bs6V9+jbnUOPU0Ru7KI=
Date: Sat, 19 Apr 2025 14:49:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: mm-commits@vger.kernel.org, lkp@intel.com
Subject: Re: + x86-disable-image-size-check-for-test-builds-fix-fix.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20250419144921.4753e30db8bd36c21108e522@linux-foundation.org>
In-Reply-To: <aaf72884-bfd1-4df9-879b-eaf082502848@roeck-us.net>
References: <20250419205551.A8FC9C4CEE7@smtp.kernel.org>
	<aaf72884-bfd1-4df9-879b-eaf082502848@roeck-us.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 19 Apr 2025 14:38:37 -0700 Guenter Roeck <linux@roeck-us.net> wrote:

> >    */
> >   #ifndef CONFIG_COMPILE_TEST
> >   /*
> > -/*
> 
> Makes me wonder where this was coming from. It isn't in my v4 patch.

See https://lkml.kernel.org/r/20250417230426.AA502C4CEEA@smtp.kernel.org
