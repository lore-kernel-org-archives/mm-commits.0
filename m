Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D304736C0AE
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802922; cv=none; b=XLwBP6y5RJENX4wr0y07zj/CTMKdYCFDeat30cFbCd1gQ9Hh7ShzFDE3i3/fDGZ/Gv4Dzo6ILMc2hOOK6BWeqzSYyhEs7YICNFuMGOU12P5SkH/uxHJNjh1tTsVOf0k++wKqZNUfvMgE2flWFtotKcQFxvVKxvKo0P6ul8WuUac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802922; c=relaxed/simple;
	bh=m0lgZe2z4+wyVlXwmfdDbM06Crm7OiE19eReP0HX3Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mg9JeUrJkYfeZDBxuMcvuEJ5bRz0eQ9fqnUaJC6FQ1xB8nGU7K2c7lxeCEecZRJdHoA+bndWe7UjxP5lKNMOKxfRIRNcCOQWu9MnYyXBtl1YU4P0IwDWjBeH7MzEgk+7h418vlnSpFYNSinEBxSPS53GvfPqzoubAf5B9dZoVfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 157B813ACE6;
	Wed,  7 Jan 2026 16:21:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 9E81040;
	Wed,  7 Jan 2026 16:21:41 +0000 (UTC)
Date: Wed, 7 Jan 2026 11:22:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zhengqi.arch@bytedance.com, yuanchu@google.com, weixugc@google.com,
 tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@kernel.org, david@fromorbit.com, axelrasmussen@google.com
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-ID: <20260107112208.1902de07@gandalf.local.home>
In-Reply-To: <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
	<20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
	<4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E81040
X-Stat-Signature: 8ym9whbabq3bzkw135aktqxtpx4wriwj
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/hTbSolWxi9IqqKEE7RRVATOCRsIe4qM4=
X-HE-Tag: 1767802901-512650
X-HE-Meta: U2FsdGVkX1/au9BKn7h6gD1kiAvLhJ/NDK3GCQZZS79X0STE/IM81b23qi1u19azjy9LICT0UxMUfyRMmOxYDLhJyVT4iSSXAsBQj1COi+qIc4PR16SyAot21qlfzsmw5NfMADQs+2Q8DsRux6zVikfTUy7doLtIiRa2yt9JFBOfdVWUw6B2pqVR4y0uPnZUuhnLQp4etBwNOk6rjq03BbPE5ShtOXD4MdJ28onyOrPu2Z6K9iy1tKr9I8V3HyajzTFeOt8hEvwsQz9asS/EhdcEWKmq4lyUEQlomvPTmy9Kkp3xGFF1VGYwoXXVguUfz76bl5tSfZFF+RfNeRlTZV7vcm5JA8No

On Wed, 7 Jan 2026 12:12:23 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > It worked for me, and presumably for Stephen.  Please tell us how to
> > reproduce this.  
> 
> !CONFIG_MEMCG.
> 
> I'll let you guys investigate, I'm done reporting mm-new issues.
> 
> >  
> > > Andrew - I am still confused as to how mm-new works, this patch looks
> > > unreviewed  
> >
> > It was written by the tracing maintainer.  
> 
> OK well that's at least reasonable.

Hmm, the patch I wrote should not have any dependency on the MEMCG.

I'll have to go and investigate why that was. :-/

-- Steve
