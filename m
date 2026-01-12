Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC82320CAC
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 20:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768250993; cv=none; b=nEwbKcVzZAZql5NmEIq19yDzrfA2sYHCj9DdIwb4w/FpQV4sN9q4SAVYJ3cXiY+rxsG2HbFWd4VtIaPeyfPi1xVvfQb7ka3Db8RnwMG0UP7c2DbmP9nVcPi7iR06o+IDT2w1Ci9eiCZQbvGaJ+jB4+4VklwDCXiG4JKB2QYICyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768250993; c=relaxed/simple;
	bh=3dv+Zg3xP8GrqF6kvmpCI6YCr5nQiCd3Ue0b/odfKsE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XsKAj5mPV49uegvrt7ZuK2l2vYa4t0BmaakwA2ikJ7RcZl35Ctt4wU4J6KbvZVJYzoKm3s/4c7hbQvih4sOA6O33/wVFsumrCZtHUL/lkGk5mBr/D2ocJPZM1QuJdrsYs8gr+YztYOGTXQWP88Z+fFGGyOXJWL6vIF3mYpvSRYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sE3TGLMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sE3TGLMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6315CC116D0;
	Mon, 12 Jan 2026 20:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768250993;
	bh=3dv+Zg3xP8GrqF6kvmpCI6YCr5nQiCd3Ue0b/odfKsE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sE3TGLMqxLkl3XgGKjgLmHn2lv5cneiaPseRE//QaAUsC10uHnsCy9ab0XlMgMJNR
	 BitTgByPd2RzvyYNTfrI98nvfUrnMRKGKC/X/ucNRY9YdzRNLLZ+Io919ivnWF+81B
	 Qg1SGJmdbPotyQvOMlzQ5ygsFPfhUvI8sIGEYjq4=
Date: Mon, 12 Jan 2026 12:49:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
 viro@zeniv.linux.org.uk, vbabka@suse.cz, tj@kernel.org, tglx@linutronix.de,
 sweettea-kernel@dorminy.me, surenb@google.com, sj@kernel.org,
 shakeel.butt@linux.dev, rppt@kernel.org, rostedt@goodmis.org,
 roman.gushchin@linux.dev, rientjes@google.com, richard.weiyang@gmail.com,
 paulmck@kernel.org, mjguzik@gmail.com, mhocko@suse.com,
 mhiramat@kernel.org, lorenzo.stoakes@oracle.com, liumartin@google.com,
 linmiaohe@huawei.com, liam.howlett@oracle.com, hannes@cmpxchg.org,
 dennis@kernel.org, david@redhat.com, cl@linux.com,
 christian.koenig@amd.com, broonie@kernel.org, brauner@kernel.org,
 baolin.wang@linux.alibaba.com, aboorvad@linux.ibm.com
Subject: Re: [to-be-updated] tsacct-skip-all-kernel-threads.patch removed
 from -mm tree
Message-Id: <20260112124951.d4b626a1785244c39445bf58@linux-foundation.org>
In-Reply-To: <1584c24e-2d13-469e-9048-c5eab6bef9ba@efficios.com>
References: <20260112195532.54FA8C116D0@smtp.kernel.org>
	<1584c24e-2d13-469e-9048-c5eab6bef9ba@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jan 2026 15:04:37 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2026-01-12 14:55, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >       Subject: tsacct: skip all kernel threads
> > has been removed from the -mm tree.  Its filename was
> >       tsacct-skip-all-kernel-threads.patch
> > 
> > This patch was dropped because an updated version will be issued
> > 
> Hi Andrew,
> 
> FYI I did not send any updated version of this specific patch.
> 

Ah, OK, thanks, I assumed it was part of the main series.

Still no review on this change.  No maintainer identifiable (by me). 
It's very old code.  Patch lgtm!

