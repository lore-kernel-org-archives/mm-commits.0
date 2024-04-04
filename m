Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037712B95
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252581; cv=none; b=WS+xZA/wO00YhGl4Y62y+EhoSmdhFyknl+lNXugecCC9YV9rP/q1APJ0VPrCy4Zve9Z1OnGO3L/++nZch/55xdydoqDbeRtRjnHz3MHQcber9P4g6MMmXIsgZQCp8u1DRgo9KsGVEnXh6STxL/vQrDc/UJMPRAl7vJmGiu0BE3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252581; c=relaxed/simple;
	bh=cHXxt2pIvQakxTlNsFQyf4y4BMNjA6NCWNWfFjUMiVE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kgKiJXYc3BIfYPDHlWOeT4/e6a2LIhqfzXhoyJQxyoAWObbfHxUGRebgKN9htBd9yDaDb0KOW6lJhyGQa5/h0MhWruO8ZxoE3iEqsecCW7Zn/zxyWlhSFhi8vsPbnJK/2RhP67iQ/zprqq/zyy2n6OXf1gaFmp70bpZdpEbZiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmWfAOVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmWfAOVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0216C433C7;
	Thu,  4 Apr 2024 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712252581;
	bh=cHXxt2pIvQakxTlNsFQyf4y4BMNjA6NCWNWfFjUMiVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NmWfAOVv41IiqX4cXdraY3wMXGHGhj8HKCXT/PynUB7UTQJJXneeSzUpEcpOaMPGl
	 odMXK5Zfc2EjSuI5ENKu+tHqVzRuTzYHrgUUeQKVIiiDKfHiwc7o1dxrFnt0c0bYin
	 wewNm+NiYarXnbKWLmWV9j3AgX4B/AwBd8N3AvFo=
Date: Thu, 4 Apr 2024 10:43:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: mm-commits@vger.kernel.org, osandov@fb.com, osalvador@suse.de,
 mhocko@suse.com, glider@google.com, elver@google.com, andreyknvl@gmail.com,
 pcc@google.com
Subject: Re: + stackdepot-rename-pool_index-to-pool_index_plus_1.patch added
 to mm-unstable branch
Message-Id: <20240404104300.ae702b64fa1be8968b19b34d@linux-foundation.org>
In-Reply-To: <e268a0e7-41c9-442e-b025-638aff113388@suse.cz>
References: <20240404015549.E6EE6C433C7@smtp.kernel.org>
	<e268a0e7-41c9-442e-b025-638aff113388@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Apr 2024 09:17:37 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> > Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
> > changed the meaning of the pool_index field to mean "the pool index plus
> > 1".  This made the code accessing this field less self-documenting, as
> > well as causing debuggers such as drgn to not be able to easily remain
> > compatible with both old and new kernels, because they typically do that
> > by testing for presence of the new field.  Because stackdepot is a
> > debugging tool, we should make sure that it is debugger friendly. 
> > Therefore, give the field a different name to improve readability as well
> > as enabling debugger backwards compatibility.
> 
> Can we please move this to mm-hotfixes-unstable otherwise 6.9 would become
> an odd release with the new semantics and old name so debuggers wouldnt't
> recognize the new semantics there.


Done, thanks.  I added:


This is needed in 6.9, which would otherwise become an odd release with
the new semantics and old name so debuggers wouldn't recognize the new
semantics there.

Fixes: 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")

