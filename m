Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A31D3385AB
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805784; cv=none; b=cK5PXO/+TvOkJMgzixS0TBRwFEtpbgdCZi+rzYvbunwYZztJUi9bE2SJnHUa0O77rdGVszriE15YBG2lKgxa07st6A5lTZ7XUUTcxLalH2RzoYl39dW1xu172aEV+L+FFjSnlB/7x1Pzx9jk2/lEslXJ9PjApYETkNfEzZbARds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805784; c=relaxed/simple;
	bh=EASnPdzBvfvS7OgpV8RgiT/lec0IwAfMG4C5spzP3qA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mS7V0yfMtWgCJFi+fnuqzR8LqSp7qY3lHdpB4k+L4pdNX38Q3bhG/MrzGUgQ1khLnB9oFJR1OAavlEQ6QEU1ulw1MPdSFstHUTK08OrYJZlcVBhGuWgNbO+iG2HTOTCVQ17IWegS2LoYoy8r7H3zQou+H7dYHRZ1mZM9r3gw1xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F2BC1D7E;
	Wed,  7 Jan 2026 17:09:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 21FCC6000D;
	Wed,  7 Jan 2026 17:09:35 +0000 (UTC)
Date: Wed, 7 Jan 2026 12:10:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com, yuanchu@google.com,
 weixugc@google.com, tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@kernel.org, david@fromorbit.com, axelrasmussen@google.com
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-ID: <20260107121001.5607939b@gandalf.local.home>
In-Reply-To: <20260107083552.9ed2e3c375f1d9971bc35997@linux-foundation.org>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
	<20260107112700.1c1ce18e@gandalf.local.home>
	<20260107083552.9ed2e3c375f1d9971bc35997@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 21FCC6000D
X-Stat-Signature: hpfcq3iatp4xzghdtxjq1rn3x57zmizu
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/fouYbTZ58fioHQnD5ie8jw9VXoYWTLE8=
X-HE-Tag: 1767805775-732427
X-HE-Meta: U2FsdGVkX1+TpfwX7JFf6R2StOqs8eOFJhs3hFGDuy0AU6FjgDoGo6rpg93Ugd447jLbeLHUZzV8BaX/bFSwvtoOgwb6OKXzivfLRTbEG/Y9GItim/OHhTlHubMl2ad08IPzDo8pOTkyxpXNZUDCvMWNvHTQaACF7sdwk4HwgbdKzAlAMwWc9IZR+Biu8G3sMojUZ5Rgd/N1gkKR13MjIYCBhfwE/51CvrTm2f0WiWAW0LxG5JC3WimoAstaolOFn1r/K0ZKuFLVkDhgRvH+A25inn7AwX3nRUrgm1GsWMfglDOz2eU6i2e1eiPch3HwdEcYuIhnYPHUaJBE+vG3fOBrFj9d/k95Zg+5eTxSZHBTd+xgqAnIOIRirlQUEUylON6QE4IwvExICViG5o4Y/I6PoWl8aoPo4rzTLozrc9o=

On Wed, 7 Jan 2026 08:35:52 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > OK, the bug isn't the patch I wrote. It's with the patch that was added on
> > top of it.
> > 
> >    https://lore.kernel.org/all/20260105160423.23708-2-tballasi@linux.microsoft.com/  
> 
> Yep, thanks, Thomas is presumably working on a new version.
> 
> Thomas, please include Stephen's patch in that series (don't forget to
> add your own signoff to it).

Who's this "Stephen" you keep referring to?

> 
> >
> > Thus, not my fault ;-)
> >   
> 
> Please don't deprive us of the joy of blaming you for stuff.

That's what I'm here for. Heck for several years the topic of the #linux-rt
IRC channel in OFTC was "Blame rostedt".

-- Steve
