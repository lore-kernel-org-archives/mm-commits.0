Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33FB3BB695
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 19:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789413006; cv=pass; b=FqCpRcoAiVlXXL/e4BRpfia4OWtC56jYahZl5sP5UHQgCt0BfcmE+UmQbUXJGzI/+XIRcm0MJbNmbBbPSXQ/o7SJRu52XES+t7FWmsBpnABwAMwt3L4iFQ1d7DeK7xiRxwrvhD0n+YY0DBUwfkzVUoW5odIjkiNwo906xGM/q14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789413006; c=relaxed/simple;
	bh=3/K0TVzDduuB1bC1NRuQyqOKhNXefGdg5h1mmSAwe3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZM4M7/fNm6J0Bmi3SvBr1EjMsbW8kVh37DZzrqk93I4POb9oMXbwfz8TGWg2RFwTfjpIRPIRRSL8fRnFd23+r3syZsBxquRI8J1OhcgdbJK3qknGvRVdB1TuM4JgBFOoBFOsSeuP5OYkFxMfT5fjboonjOShtYFp0ZwfpxFUnnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YmByknW7; arc=pass smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YmByknW7"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so420461cf.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 12:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789412997; cv=none;
        d=google.com; s=arc-20260327;
        b=ZptOKEaoXy0n+SH2ygNj+TDb9wT79nZSJyRadT5HpOIa+GmoWFLZPtDzSm3NS50UUy
         wPUmjD5lmD3C6CB26XpvK3edUZx/nM1+YPhnP72sCqMyIoIy6RGQ1Tm14pkI3PkGpahJ
         ROY2kDj2pHSds653D4k9KumFc8lsXGNDh9W/C0DmHaL8uFJDTAeit2folXeARDP0GNeH
         zHhlZ+s+CVYOZ7X/j1VBrCO/6uYSRGWaBHDV5rmcLuO34CQH6ovniQmbhQQFbn2y+yN8
         L9PUsT7hh6jRnFifc0yyXGgVn0E61jmxmjqVTAGs0IPnrbPzZdilM36ol+TGZot1o5xL
         RUDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        fh=Mu4qeZK50pgjsEe7RBKNSjRs+ScTlkKjSrqNIDNlcWM=;
        b=YFUg+WrtVWGdAQW6/2mxRt2btJmCgsnouGydTQig7FXqDc5B1EvaTp3DtIVA9j6RZL
         NFK0pj/3+n54lCJzV1LQSbADduVZhiOr9Ri1A4B1R+nIEYAB5PdlURS3H7hEI+IXxVyd
         ODjDJNKPwp2gLhn2DlPNdtyhQd1lqa8qKJ+1rgqeTVNR2XRI884+tw5lDVpeLrJFo/3Y
         3E6sH3WMZwksuAqhmfwT2BBJyyUhP4ynvYfWKRUNeZQxGHsUx2ct89dKd8aZL5QcQm56
         IPO3jH9ZafTv4cuWD8vn+tBUzpXzXSXQ2la9ZKPoOFfFkAOsYtG7JbVpo7j3gpRY8eGQ
         E88w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789412997; x=1790017797; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        b=YmByknW7sA/KqPfezEEECGcM0pDgHw6mqQiR2a3y3n3FTAmHJJTeByjpkrzMGIyRvW
         zls4tr8rOAOMmRX7wyRGU7/1RKx0I9cv2sNAc4A9PDtE8HPjf7L/VhnMbdzwe38z/MYs
         E8rqVek0wuJwNJjqEK/ucC2GTF7m4nwutj7S1TmF56zdN2TqNZ+GQM0FZh6QVAV+EikX
         3atOja71lsMLk9v2bPu21DQ2cecPcMzW6kV5zBSt01JOXM7A6sZ/w6WvgmZqsXa8PuHC
         7He45mPDEWJH+BHGRwvxJH/2SwRUUCkbdZdV/4EnZkBaIUjfICn7Z5KbGwVF1V4wlYdY
         8wUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789412997; x=1790017797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B9HHz7xqKOBgQRJBunlMxL3q9HNHJ9DU71Gm8Qozrv4=;
        b=EoTs0Rz6IduDnnLjbVEMR2BAr67GlKwNPm/In0sSQyg9LEKUo4pQtXtulFgMep56lq
         2O22tUJbVbZTZw7iONyA9jcE92Kx8g1l/QzHMM+YkaT+vXt/PaSED3l9sIIqX42qXkH6
         cAWmS3D62esv5FF357Cu23WKep8V8djDi6aRlcL2vsTkUgZ6kBelnqld1UqX5OSCp8zu
         2xPCCXuW9Ej8lWYG+c2xkveOD+i1v5gHKyYYbAbTc57yqGbbZyDppfFtPoFO4rMJ1Gc5
         bjIZy78sor+YAp7SEinBno0xy3IzVpRaT1DdtsWBzmyGE1p+sEuAPD5Gjt8oG7J0se3F
         zbzw==
X-Forwarded-Encrypted: i=1; AKwUvBzG611Lc2n8X9KxPyWYf10awtKLMLDYKwB8MXX+s8dRKP6R6cikHwiCr9HQBDLEa0nOdKs8rG83mynN@vger.kernel.org
X-Gm-Message-State: AFuF++l+8vjRIO6aUwdT41ZjPzONSbhbzFaefhXm2t3u+PMMQ1PPTenY
	xmpWA1VHHHWqQ7U0mTCAbIpibLMaPh7xxDpukrzBY0s6+PDvdssS14DsIpjS8HZdvUGIX1h0ROK
	241o7+wQk7ebJL90UXVidLyLODKennjkWxXm8Q3FKtf7SYZXR3hSHtdUeSqk=
X-Gm-Gg: AYBFou1UKfESPEIpNmTq74ULA1e5QD0AeyYTjLeDHerU1bhqcq4C+iqoD2W9f8Eni8N
	G4mBdN70nDD61MtkP5qfH2flAg2dJFkznX3xFm89ruGlxISOXeaTiC6qjBwSyzPqrmG+txiGR7b
	55/1jGmHCXk//7jDpOS328HWST8WG1GJccrbAlhlcCT+Rc/Rbs0VOpNTFzRnODK6kPME2eq2fHh
	IbVLjuI8oiSAEce2kxUj3NGT1Jivxt0F/92YPVlFJMOj2jZUjVK2NFk7YrD+KabubOu1NAZV8ml
	UYaUGNrDBbFhXiWBOK0t2Ml5leRO3XdyAv6SKraNTwTHFIkvnS1nTq58h68pqKVGvii6mB1qSnc
	z35fIjqICww==
X-Received: by 2002:a05:622a:5809:b0:530:3f93:9023 with SMTP id
 d75a77b69052e-5311a5c4ddamr3464331cf.4.1789412996591; Mon, 14 Sep 2026
 12:09:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609121422.hkKWuy7K-lkp@intel.com>
In-Reply-To: <202609121422.hkKWuy7K-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 12:09:45 -0700
X-Gm-Features: AcwNN1V0cr3-51H8jG05tRliUGeoBV1UMLQnVvmfkEsxoTHflVeOK11wY4wInNQ
Message-ID: <CAJuCfpEzfP8nWnD2v6Wfb73h7ejD4NHNqz=TnXa18pvZgWz6ug@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 439/459] fs/proc/task_mmu.c:205:13: warning:
 'reacquire_rcu' defined but not used
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	"Liam R. Howlett (Oracle)" <liam@infradead.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 5:41=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   383fc05d4650b021f3c17e36a145106dcc61a294
> commit: 2a61a4b80dc01581dc9f6935eedefbd596e77409 [439/459] proc/task_mmu:=
 remove unnecessary inlines in function definitions
> config: openrisc-randconfig-r053-20260912 (https://download.01.org/0day-c=
i/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260912/202609121422.hkKWuy7K-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> fs/proc/task_mmu.c:205:13: warning: 'reacquire_rcu' defined but not us=
ed [-Wunused-function]
>      205 | static void reacquire_rcu(struct proc_maps_private *priv)
>          |             ^~~~~~~~~~~~~
> >> fs/proc/task_mmu.c:197:13: warning: 'drop_rcu' defined but not used [-=
Wunused-function]
>      197 | static void drop_rcu(struct proc_maps_private *priv)
>          |             ^~~~~~~~
>    fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used=
 [-Wunused-function]
>      133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>          |            ^~~~~~~~~~~
>

Fixup is posted at
https://lore.kernel.org/all/20260914190631.3167420-1-surenb@google.com/

>
> vim +/reacquire_rcu +205 fs/proc/task_mmu.c
>
>    196
>  > 197  static void drop_rcu(struct proc_maps_private *priv)
>    198  {
>    199          if (priv->lock_ctx.mmap_locked)
>    200                  return;
>    201
>    202          rcu_read_unlock();
>    203  }
>    204
>  > 205  static void reacquire_rcu(struct proc_maps_private *priv)
>    206  {
>    207          if (priv->lock_ctx.mmap_locked)
>    208                  return;
>    209
>    210          rcu_read_lock();
>    211          /* Reinitialize the iterator. */
>    212          vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_e=
nd);
>    213  }
>    214
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
