Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A86483827
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398124; cv=pass; b=Hw9XUNEgk3t/hk00OB9xmO828Lc34ntvx/n8EXvNdlDehwHkYkoKr7M7jpUgKEWUft4ci2bQ5C/LSZdpw+VmGnVvyh5jVF1CloYPhyB0we38KP75K9e/jOp92s6ayy36vks+Ij8ztqYHe7dnAdF/2Cb3PnZrcoq5K4xVz3BEkWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398124; c=relaxed/simple;
	bh=1EYDlemeLWv0WTFuJozt+j/0ztk4MscH/Q48xCi+/tU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=btBehMk1dzco7HU2kX6lY1GOHPGGRUzl1oMEg8yGy2FGCHiUx7U53MftgwGfGfL2NBeR8G8Ulvj9vz/b3896Dn/FLHsnywJqvTsEhcLz3RSvEutX9bfOfJp1ZPh3WTbAakVscXcuxzvPRGgsJrf5g+htMLdYtUOjw0EfV9prAHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtPSA7RS; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtPSA7RS"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so375971cf.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 08:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789398120; cv=none;
        d=google.com; s=arc-20260327;
        b=KseYOHgtOAvTTqvBf6rsVy3K8F4WryWhkFU0nE4iWoxqwvSQL6r8hoO2NHNR975kHZ
         Rwkzw3Ia9iifsuT05FPR8K66+7/iqTsrNcsWobRb/Adk+cJl7rgsuwhtbZiyAAfPdi7H
         LKPMGuD/hUiXqxhcwh3Hk7lrcqilWwDNx2AzwspyehP56F5Smgnjb4gm/S3Y89KieyLH
         KhXB5Eb2EKlqUGofD50CEjv0A+bpeeIZun/2xaZCXBJ37AldUsb5Qtghv5HFMcP5YYW7
         Y+HG+d83deZxWPERg2s4X38offENM5D/1meARcu+r2PwuUR9vlS2AoqqGYn/OinOZ1V3
         l6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        fh=FHHcJCowFiFB3zrr1vd8z6iv+CMA+nub/coK7wl4S84=;
        b=YVn2BSwdHYD6XtkiMv0amgEQImFRu32d9nhcbWHNysw8LaPRzgioWsjOc8MGuef0og
         lczFpq1nFDJDrmK0q37u5tHwTtbLzVRrrYfQIW6wiCANo730cRznfrv0u8Zc+ouLNspF
         WMuKJdiVQBeVRtWet01E0rKARwiV2rzpeNAXkNg8YDQsdM7QfmiNcIkgbILCyamlE86g
         4zt9u9q1xvVr+1xt1Q6raVmtNiDrpobtIUnwZ7LsL0EUcm+QdjD0Jif8TWbhNM1xfofg
         MrRFcvCrC9Y8QMXbFzEeSAezJZApjKxwGdf6y553KXxCROY7Btz8C4VApK6uOf63JbTB
         6vdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789398120; x=1790002920; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        b=MtPSA7RSQoNiPV+APnmuQkSzgKCnkQAzhCQDB7+GirSASOM0h6Ui8TrvkD2vbdRYcB
         6h1KRK5YhaYgyo7EEUItFalsIYo2cGTPEnPVZgmJq7IPfddgiOpyFTkYnSpESqLNc7Fa
         aW1lrWIZ14npYvzDqOW2Zl7gEmtSV/ofdOEpS5tuhh2uBzY+fAwXK7o5OH3KycuPXccH
         iYt3/ekCq8Kc20dm/EQ6eD7/Bl9imV1tzq9fmjOR7I18VuIFqfcW7f+TaZ+CDkeuSoyd
         byjZ+vyrUHrFJnugMv0+8cgj/BM/ejtOlk83J45y8wRmBbU0m/y5YPmNJ0DnrAu1QgFP
         5VIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789398120; x=1790002920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzUqKcWXaytoxZ9VR531dfCrQ208kTEYqL04RpaAkkA=;
        b=rJMLebl4kDsDMj+3WKq2XVy8+5zHbwJGkW8FlJpuyXOBZ290StErQZ9lezZyNQK44B
         YKfK1RC3KkAw8XWusembKdWYf81yfjvPyqpzBtxhsJ3uKmRxhOSSGZvO5LzBmjXlk1iK
         vGWFkHMSUfRvO+zEWeoTOOxZBUMIweaSclLbsWI0LtUS+7IM6nhBQcxntb1i8fiXgGH6
         tUlgsZykbELtLX2y27Uwjagzj30mwOv9WYc44sXdk9jxuF37zSExtn4RIBYCFl26W1GY
         iDihnirD9oKdKFy/1vNFWGLAcXTni4qULVLrRFZ77Q2/Ud569SPEtRG2tSjSomAH1Wbz
         RXiw==
X-Forwarded-Encrypted: i=1; AKwUvByGbie/y1GH4YGwLWbhbTU5G/yKF5I4jf3rWOChdbmKRfLrbGZEMChKwXUuUvCgH9Ew9GjvfawK06r4@vger.kernel.org
X-Gm-Message-State: AFuF++mbyMCaMhfOYg9dNrtFb8b0yxsnNBGmPXkkeV4kUUXk9RYIyDqS
	K9ACQ9Z0Xdhh//CXJ81mZR+zSzSydVAqLcgoF/JrwIMEAVeTHyxUEHc8b0hp34O28E9pDRXcntK
	ihwShFRqa8zrVQGFKmN6fu4hXkk5p89aTKawgT4s0
X-Gm-Gg: AYBFou0VIckO7hKkqkILDjAhLW2tbbYAElLXfB2dGcWr0KekiFzRuPWbKUvDJTnCd90
	QNRx2HXNHY4fzFPUPbBRA+AMqzLdn87kn9nKzYu18jrpxVkIkBtjfwSmONwCFQgXF6bMTr01LHR
	mQHD+Jvy3ESVbRCLvStbDN06Z1fOCLg/k6yGg8K9mucgR5TQw1YYQNs4rq6oMUgqhP9R1zLyRZY
	Dlj+unIsUpPLVY37HT7fhStjV3TPnTOsVYWhIw2y3pW9bnIwuP+AhF1XbXf43eDRWb7hH3KFAYu
	bY4BDvgMOZU8RbAzswsFSTD+cOnZaMS9svwKDV6Mi+yGGMTaFwEj0Q==
X-Received: by 2002:ac8:5a0f:0:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-5310ee4bab2mr9559071cf.7.1789398118911; Mon, 14 Sep 2026
 08:01:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609121422.hkKWuy7K-lkp@intel.com>
In-Reply-To: <202609121422.hkKWuy7K-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 08:01:45 -0700
X-Gm-Features: AcwNN1WLIuqFwJiP12OvUDtNJ_un5ijm7vW8SviOfyPSvZRrA42nxpsFR-V1QmA
Message-ID: <CAJuCfpGoZTELakrjKw1Up0eQnSTgXnuhADeRrQKPV+xPhtRy2Q@mail.gmail.com>
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
>
> vim +/reacquire_rcu +205 fs/proc/task_mmu.c

Looks like these functions are not used when
CONFIG_PROC_PAGE_MONITOR=3Dn. I'll post a fixup today.

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
