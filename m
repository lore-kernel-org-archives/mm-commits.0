Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9305318B93
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803754; cv=none; b=fQo3bSyiqHxeJPHAy0eW1e9izjAgLytRwM1AWcKz+/OUEcmkP24HzGKx2ZfO1vzONnSyC58oMetGm71kZThuWIApX77jWxNOCBQjoZnkfS9r21oD3oiAeohdzIMMPG+oK9w3r3myNtqlZm/fn7vuvbQWmHyx5weR0wSgepPpzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803754; c=relaxed/simple;
	bh=52KAM+dj47yS2S7Frn5arzU8CC6s1z7UNp8kEwMhfRw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=R4QzCbpaQ5UDIPinBXezJoUwZmgJeFg2edZk25ROJnHCxXFM8lOr8J6lsVUJUoyAASqejGN2HGWlw1WK7anrFIHPdoYVHx0kpcTKUSy4gRwjDpQNoENP+4dADGpTiyVrZKS4jno52w3C2N+YFlsbiQJ/EbVzUo3Rzwn+Ky1sQ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r90q3MaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r90q3MaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFE5C4CEF7;
	Wed,  7 Jan 2026 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767803753;
	bh=52KAM+dj47yS2S7Frn5arzU8CC6s1z7UNp8kEwMhfRw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r90q3MaIwW6yleNRXSxStd4YjRtG2gLOn3ZEwfaic6WiChAQfeB8G1XT3JYeV6loE
	 zA6VTCGPBVpYcJAOJmE615fmiyITBVIwk75OtPTDH6qDtodpCPIw+pazQXO3/Ik37S
	 JnLpSbj9i9Vd1MPknFiP2+OQfZSaziMRR4mqsaKE=
Date: Wed, 7 Jan 2026 08:35:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
 weixugc@google.com, tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@kernel.org, david@fromorbit.com, axelrasmussen@google.com
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-Id: <20260107083552.9ed2e3c375f1d9971bc35997@linux-foundation.org>
In-Reply-To: <20260107112700.1c1ce18e@gandalf.local.home>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
	<20260107112700.1c1ce18e@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 7 Jan 2026 11:27:00 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 6 Jan 2026 17:30:32 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
> >   AR      arch/x86/entry/built-in.a
> > In file included from ./include/trace/define_trace.h:132,
> >                  from ./include/trace/events/vmscan.h:554,
> >                  from mm/vmscan.c:73:
> > ./include/trace/events/vmscan.h: In function ‘do_trace_event_raw_event_mm_shrink_slab_start’:
> > ./include/trace/events/vmscan.h:238:68: error: invalid use of undefined type ‘struct mem_cgroup’
> >   238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
> >       |                                                                    ^~
> > ./include/trace/trace_events.h:427:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
> 
> OK, the bug isn't the patch I wrote. It's with the patch that was added on
> top of it.
> 
>    https://lore.kernel.org/all/20260105160423.23708-2-tballasi@linux.microsoft.com/

Yep, thanks, Thomas is presumably working on a new version.

Thomas, please include Stephen's patch in that series (don't forget to
add your own signoff to it).

>
> Thus, not my fault ;-)
> 

Please don't deprive us of the joy of blaming you for stuff.
