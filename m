Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39B415747D
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358128; cv=none; b=QQ0991WWBFpuAus0zaHa5k7tfDNjuD61QsgN04j/jFdc6wlxwwiroVdLYV7nbJKbUqdaHQmgiU5yj/YJxJLtJGsU11Q2PBQiHtClNLb16uXoy1pZwNh5vcyNF2qN5yYX/P/vES7EFq73qN8unm2GyRuGLHuuxnzzWn4QqiKrnos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358128; c=relaxed/simple;
	bh=pOSJ/3iFz5NvMcKlg3aWDtizRMk8ZhI7cmc125l26Hw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kKfylFpR9nyh0IYzbseWXK9j2ywF0+sj2EfKrV0b9Yy7SKXprWLVi5BxOlYVV+0QFa/TPHp+Vd9+7AlsuQuqMDP90gfooG+wY2a4D+b6EW1Qiro4bU+PovVkfSE23T5SAoWhIBODAGQU2qfjqCxC1vJLWcOpRuSeiXUlzF3fIIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I77iuKXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I77iuKXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA9FC4CEEF;
	Sat, 12 Jul 2025 22:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358128;
	bh=pOSJ/3iFz5NvMcKlg3aWDtizRMk8ZhI7cmc125l26Hw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I77iuKXHc3QkoHlXDaq2ondul/C14g6azoWauocnJOlTt0zXPCWCL0cdYHrLaciCI
	 pliw0XQxTKaYuEkqmfaKVQ056KpVTImkwB6fJZomc3TPflW76/WNNFUNgtiZ6E9CdS
	 v5jwD7mfi95OoPbYV/+6QEKV9HEcn18Inaun/9K0=
Date: Sat, 12 Jul 2025 15:08:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
 mario.limonciello@amd.com, dyoung@redhat.com, dwmw2@infradead.org,
 bhe@redhat.com
Subject: Re: + kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
 added to mm-nonmm-unstable branch
Message-Id: <20250712150847.2570af39098758e28c331645@linux-foundation.org>
In-Reply-To: <CAJZ5v0gfiM=E3ZoV73cKpYE3oVjQT831UUOa0KQxUjp7j9bLRA@mail.gmail.com>
References: <20250710215352.A170CC4CEE3@smtp.kernel.org>
	<CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
	<20250711160617.077fa359b09a337daf9defc8@linux-foundation.org>
	<CAJZ5v0gfiM=E3ZoV73cKpYE3oVjQT831UUOa0KQxUjp7j9bLRA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, 12 Jul 2025 10:15:14 +0200 "Rafael J. Wysocki" <rafael@kernel.org> wrote:

> On Sat, Jul 12, 2025 at 1:06 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 11 Jul 2025 10:35:31 +0200 "Rafael J. Wysocki" <rafael@kernel.org> wrote:
> >
> > > On Thu, Jul 10, 2025 at 11:53 PM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > >
> > > > The patch titled
> > > >      Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > >      kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
> > >
> > > This patch depends on
> > >
> > > https://lore.kernel.org/linux-pm/aHCsUAhqRz5zJH2t@MiWiFi-R3L-srv/
> >
> > I noticed ;)
> >
> > > so you need to queue up both or let me queue them up.
> >
> > Well what's your preference?  This was unknowable from the emails as-sent...
> 
> Yes, sorry.
> 
> I can take care of these patches.  They should not clash with other
> changes in kernel_kexec() and they are related to PM.

No probs, I removed both from mm.git.
