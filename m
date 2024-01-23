Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C4D8C08
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 07:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705994930; cv=none; b=EtyO6jM+FeleRoSnL91PMZtHUq604homURZ/VLWKNTFblInmii6qYi+CzF4oRD1/iRBPH7lSqdWTsxtBVdTnndv+5NZwCF52m1V99YwqbQDdpDprXAWIJwJQjZ80XVyNI4v533PyI+9+NmiUxd5jq/YAcKcGeUsgqbr+aHxKJtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705994930; c=relaxed/simple;
	bh=tHDZyxRiw2ALWk8SH8UGjyZTuthbbcC4xioWp5HMlcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KT18rFVy7UpOgnndooKPWYcfe892dnGdk3Su/I+Qf9/1FuAkv79mhqylYYkZLjWa1evcmZo35pIk33JJuRTel/sqlvFkXdE0GiXhAt2O3T78dQbI5miuZFdoK+snRDzTrhMm3gm7gU2M5QtkRs9GdTsLKXyWmvlMJqBgKXwWUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RpbHmjkl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RpbHmjkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705994927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2EmHJ8Glkp2fth0TLRBSTEpAvcdlThj06HaVQg2BC7o=;
	b=RpbHmjklpRvWWanpg/NWHO6FMEhscUKql4jHQpAqCZl85iu9f1aIY0U+HMQk6RyGm6pfiv
	6YULPCh8Zx1WQNUSNZhaRnBj5joNkBMgkAviRkDisi1llRMKnvepoAoKLiPeNlRQhaxPhL
	8NVks0W0MotpCdc2rroU6TCR9fJQHZI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-JOhmQGVfMButW6oZwqXXUg-1; Tue, 23 Jan 2024 02:28:43 -0500
X-MC-Unique: JOhmQGVfMButW6oZwqXXUg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 710CF185A780;
	Tue, 23 Jan 2024 07:28:43 +0000 (UTC)
Received: from localhost (unknown [10.72.116.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A629E492BFA;
	Tue, 23 Jan 2024 07:28:42 +0000 (UTC)
Date: Tue, 23 Jan 2024 15:28:38 +0800
From: Baoquan He <bhe@redhat.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	viro@zeniv.linux.org.uk, piliu@redhat.com, hbathini@linux.ibm.com,
	ebiederm@xmission.com
Subject: Re: + crash-remove-dependency-of-fa_dump-on-crash_dump.patch added
 to mm-unstable branch
Message-ID: <Za9qpnqY1eGnzoW2@MiWiFi-R3L-srv>
References: <20240123004403.54547C43394@smtp.kernel.org>
 <20240123055928.472239-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123055928.472239-1-sj@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On 01/22/24 at 09:59pm, SeongJae Park wrote:
> Hi Andrew,
> 
> On Mon, 22 Jan 2024 16:44:00 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > The patch titled
> >      Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      crash-remove-dependency-of-fa_dump-on-crash_dump.patch
> [...]
> > 
> > ------------------------------------------------------
> > From: Baoquan He <bhe@redhat.com>
> > Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
> > Date: Fri, 19 Jan 2024 22:52:30 +0800
> > 
> [...]
> > To remove the dependency of FA_DUMP on CRASH_DUMP to avoid confusion,
> > rename kernel/crash_dump.c to kernel/elfcorehdr.c,
> [...]
> > 
> > Link: https://lkml.kernel.org/r/20240119145241.769622-4-bhe@redhat.com
> 
> I confirmed the original patch is making the above mentioned file renaming.
> 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: Hari Bathini <hbathini@linux.ibm.com>
> > Cc: Pingfan Liu <piliu@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  arch/powerpc/Kconfig    |    1 -
> >  kernel/Makefile         |    3 +--
> >  kernel/kexec_internal.h |    2 ++
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> However, seems the renaming change has mistakenly not took here.  Apparently
> for the reason, I'm getting below build warning on mm-unstable tree after this
> patch.
> 
>     make[4]: *** No rule to make target 'kernel/elfcorehdr.o', needed by 'kernel/built-in.a'.  Stop.
> 
> I confirmed the build error is disappeared after I manually rename the source
> file.

Thanks, Andrew mentioned this issue earlier. I will send v3 including
a fix.

