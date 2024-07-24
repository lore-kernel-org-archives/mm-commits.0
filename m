Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723C158A1F;
	Wed, 24 Jul 2024 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842674; cv=none; b=gOq+itiZiM/NTV+ukAe06rbRt//U+YYTzDFAsjqCtGuiGReuYpWRcWC6t2geo3AQLrvF3SzfWucjtfAehmsD4J3mWSJbvzjsPzlQlMzUIBPz7tsXsJvOM6r6vHci1yeiz2zuciwUiAZPTZ/pbX2MEhfMnzQKUIV0lggpNuuuxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842674; c=relaxed/simple;
	bh=f6VuWljiCI7eqOIXWlyHK73sQUfPuWoDHqeHxjR4gkY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MVZMDum+i7LadDY+j9tZfs9fEvoUK4c/j/GQSNn6fv3+t9Z9xa1bh09BAb//JMLldgLpYVWeulQf4dLKl7dO2NPbICvwRRJHvPgcXmLseq1RN+g2JPTpIEBYVCST+KE03Mot8SAG3AqvlE8Avhh1GkPZ8T84OznniFn6wYWfln8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DZ/YlqKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DZ/YlqKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489A8C32781;
	Wed, 24 Jul 2024 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721842674;
	bh=f6VuWljiCI7eqOIXWlyHK73sQUfPuWoDHqeHxjR4gkY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DZ/YlqKQsXf1rN/ozob29X7zkd14frKWHMthgZBxHSfI5KIItfnTWoRPw0GmslbLJ
	 xIZGCTZUULqFUXugwIFTYdMYAnSnVDxLlz2PnZaOE9v2hPBd6O4pRmqSfyskYz4qb1
	 MPNJqLU/+M/HRKy6ch2oZUkDT25SiITBUm5o6AT4=
Date: Wed, 24 Jul 2024 10:37:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: <mm-commits@vger.kernel.org>, <will@kernel.org>, <vgoyal@redhat.com>,
 <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
 <stable@vger.kernel.org>, <robh@kernel.org>, <paul.walmsley@sifive.com>,
 <palmer@dabbelt.com>, <mingo@redhat.com>, <linux@armlinux.org.uk>,
 <linus.walleij@linaro.org>, <javierm@redhat.com>, <hpa@zytor.com>,
 <hbathini@linux.ibm.com>, <gregkh@linuxfoundation.org>,
 <eric.devolder@oracle.com>, <dyoung@redhat.com>, <deller@gmx.de>,
 <dave.hansen@linux.intel.com>, <chenjiahao16@huawei.com>,
 <catalin.marinas@arm.com>, <bp@alien8.de>, <bhe@redhat.com>,
 <arnd@arndb.de>, <aou@eecs.berkeley.edu>, <afd@ti.com>
Subject: Re: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
 added to mm-nonmm-unstable branch
Message-Id: <20240724103752.f3ed5021d203d5e333b47873@linux-foundation.org>
In-Reply-To: <7898c0c5-45b6-9795-74a0-f70904dd077c@huawei.com>
References: <20240724053727.28397C32782@smtp.kernel.org>
	<7898c0c5-45b6-9795-74a0-f70904dd077c@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jul 2024 14:44:12 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> > ------------------------------------------------------
> > From: Jinjie Ruan <ruanjinjie@huawei.com>
> > Subject: crash: fix x86_32 crash memory reserve dead loop bug
> > Date: Thu, 18 Jul 2024 11:54:42 +0800
> > 
> > Patch series "crash: Fix x86_32 memory reserve dead loop bug", v3.
> 
> It seems that the newest is v4, and the loongarch is missing.

I cannot find a v4 series anywhere.
