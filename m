Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243A920307
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705506990; cv=none; b=m5G91pmlyM7cDkr4u6oier/27gzIPg8iVjGQQADB/uiYOJyA9D7Ipw2yBLJayZHSfp0Ju7MQmaEkXHshx+vpWqgMqFWUfsT9ju/wYtCVr6EfQJZePsZTuzehEpMsg4NMTsKt4Goj3PvOE6zzpUkp/9MpzB4+c1FASWOy1abR7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705506990; c=relaxed/simple;
	bh=ZDqP9k1/sbc6SBJifGibj/3tNrZPQUHd/f8QV175w2I=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=LJm5ddzP9f/W+12tcPuS93wufboOPCdbKkbp0AjgS2AmpcU5BDVLwHeKXc08rOGXIp+dqxat28kF0Y/SvCj6xmfjEBNVHsGSHEwJiQddlaHHqVFVdyYkiKwEJun2oYWUVsfxd/OrkGSe29k4cIQG99vd7Y3VRHq9XVYNnCqh15s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=x+8EYlvo; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="x+8EYlvo"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7833bd8be24so495471385a.0
        for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 07:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1705506987; x=1706111787; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tUg5u/ZeiC2I3FNrayb5uNxhjfUg5HbQuO5CYu43svE=;
        b=x+8EYlvoXyeXDozA+v4NzvO71dof+1Il7vyVMr0a8R33gTrQG2sv7XqPeTCFqXi/2m
         4YYPL03Qc2jOxpti4P0J6YCOOfNlJyclxpgmm2hBjSW0gKsra4cB1bsrqMAItOf/DmpV
         IKVO5p+6GyoE0jACjVN5pcTssCb8vgZXksLKiEsH9YxbGyy/dZ/RWRBMlArSYij0VKOn
         JWE9epEuubNouNMNnzcXwD4oCY0J8EI/d1SpONIxIamBjGJfZ+Vy5XdazycTQ1lj7Y/3
         UeAgla6+7haFACfo3hi5a6QerVkH9nk4nX/AY+U7YgyxjQ/hIiUr05VRc4B8PIQDMO6J
         c9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705506987; x=1706111787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUg5u/ZeiC2I3FNrayb5uNxhjfUg5HbQuO5CYu43svE=;
        b=jkxuJq9KCIVP4wLANHgitSiKQq5mUMfnAqChUjqsm2oKKEReL+7Vh5DxKuSr+URVEP
         Tl4N0fNffY25qn20fkHwrSh2NhS5BQ8cRa76klcN+s9r5Fv2W7yU86rrUOyrszNklMnB
         L2Ou1yJC9ktqP2HPNrL0FgpNy8+jCMJNDOE/cPNCcQ+PELm5vPmU5ZN3YAbkSJsXgB+d
         maTNR+fRZtnr5sfZdhuIUuHOCyaX/7qIoR/QzgILztDlF0u3DnHOh4J3xDJ+rGHL9r0/
         RDgD36TqPdIRBRI7J6Y6jpwtaFAE87+Zf99azQHzvQyn3REQQx/J+vEKXpCo5b1xz09u
         36mQ==
X-Gm-Message-State: AOJu0Yz7/u9P4qTZnD6E2RplfnYR8YUmqTQAyutZ0KM+dANzfmtHpd9y
	Ij4G1hk7m/BskAuf4atOPTeMXqtNGPvLK5CifU9oiDChG3Sk8C9UBhRm7eRVAuw=
X-Google-Smtp-Source: AGHT+IHZW45jEen5Hg4GvnUa/+hsYf7z+Fv/PAJYCC49n+E4OJ79y9b2RsfaxmSai9qikh/od5vt4w==
X-Received: by 2002:a05:620a:2591:b0:781:e4cd:785a with SMTP id x17-20020a05620a259100b00781e4cd785amr1376085qko.21.1705506986918;
        Wed, 17 Jan 2024 07:56:26 -0800 (PST)
Received: from localhost ([2620:10d:c091:400::5:d195])
        by smtp.gmail.com with ESMTPSA id h6-20020a37de06000000b0078353f07523sm2657620qkj.1.2024.01.17.07.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 07:56:26 -0800 (PST)
Date: Wed, 17 Jan 2024 10:56:25 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	yosryahmed@google.com, tj@kernel.org, shakeelb@google.com,
	schatzberg.dan@gmail.com, muchun.song@linux.dev, mhocko@kernel.org
Subject: Re: + mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20240117155625.GC939255@cmpxchg.org>
References: <20240116214549.6E4EAC433C7@smtp.kernel.org>
 <Zab_tRKQzSS25ugy@P9FQF9L96D>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zab_tRKQzSS25ugy@P9FQF9L96D>

On Tue, Jan 16, 2024 at 02:14:13PM -0800, Roman Gushchin wrote:
> On Tue, Jan 16, 2024 at 01:45:47PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm: memcontrol: don't throttle dying tasks on memory.high
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch
> 
> Hi Andrew,
> 
> there is an updated version from Johannes in the same thread.
> It seems like you've picked the original version. Please, pick
> the new one instead.

Oops, yes, thanks Roman.

Andrew, it's the one I replied to privately:

https://lore.kernel.org/linux-mm/20240111192807.GA424308@cmpxchg.org/

It incorporates Roman's and Yosry's feedback on v1.
