Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1F27BB17
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404683; cv=none; b=nhUlBiY5yzZzqblTWN/6B7+W46Q2/TcY8dfSKmLd7MKGPXvt0R5MlmROiHizgvvJDbktvMclaOGR7SAE8W7E07cx/5K6Kpe2BkIgLYfT7Ogm5qlJJFYTLu8kvzzjqGWN4glXCcBjfBm0Y3WeSCVfmPNcL3ZLKQ23YlLqMS5QM3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404683; c=relaxed/simple;
	bh=FyOvVKEsAdjrtZfxR0+roCRV+TLNdqHJuTxuqCALNSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwS0fJR77m+F2wuTYrSUFpbO2UuPOn+Fnxm2YXCzb1CGQo3jRMiWAotY6/DJLvqYNJBgKlekw4OdAoqcmr+OMVG7vTSprm6zgOnd/60yBoREqropH8RfwyVVrbUcjLkSOqGzXykAFWp+mfYHzcyVAt15fb1hzAkFoMvp3yDcalE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5y30BW8; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5y30BW8"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f013c304bbso193163b3a.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 08:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714404681; x=1715009481; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gEKeA+Tvb0c0YFGrgaIHSaw1SBpSGU5Vil59XZf/Cgk=;
        b=I5y30BW8j+fYlTdd+gSYZicKYXYK9Ld2JpWlTORo/03sztRsBe5aGB18ggNFN8PFnn
         veXWqvy2M3bGJwYNBCog11zb5/FRWVUvR1XHPAES7nj8CbsH846OoglSP9iIQy3sJ9zc
         Tk9UL2stE2wBIdvDD2LO1ZOzw7xS0yfP9TM58V8Ra5xygZkzyiCei3qpVrbtwGjwxM1e
         19WAjwpWT4EvxoDhu6rUZ4U3YAC9wdVfHgbF+dBSeZEJUMFeBJjdvM5ufjaX+c8HhTY7
         9c/AODC89xvXLipU8JpjUJb+9h4X8DPnPHlmMREHfldqnY9q9B+8JwNObzeMdSWlUmq4
         E9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714404681; x=1715009481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEKeA+Tvb0c0YFGrgaIHSaw1SBpSGU5Vil59XZf/Cgk=;
        b=Z+t71O7rBP608X0mnhNKNV3VkrljmGmADG380ydyVE5uRYsGgeNv/BuFpBFlxrlNLW
         Kkzg13WI0eCS1fSED19Z2+qXIOueaEWEn8hAxj1jn0O+b3UeGhZsNMDxFRXoO4GHAGMs
         5o1xl7o9gWPxHjIccjC/l58g6mmisj2dGQ/X0ji8Rj15/fWHSMou3tGQWx6h8k7xlkiD
         Hf+iZcHFO/r4A1r42BlRNllVimNZnqkLe5Xo7nXthk1RGo9KYIyW8xw5NI8EBpSWbuou
         kNeewIWqIM0em+ijBwz9bsT2j1WGZsoq6RNPZtSPmdDM5o9KXJTwnksXVzmtq3Ep8igj
         N22g==
X-Forwarded-Encrypted: i=1; AJvYcCXly4ybaBmS0EXTUecd82SE/sJgIHLOsqkMW8AJxbMDjHtSfx/bGsGQYRF/u9HoCveNePKrztsUXQyM2B6YzoFmXlDA+qQEJHixYQ==
X-Gm-Message-State: AOJu0Yxe52uZYNgZZo3s69Jb/5GiCNm5ijL15UNmnH1+zVwHjYM1zYjx
	VlXQsbF+Oaf9D1wjOw6WhCfFXQHsjilnj+dGC6Q+emK9jU+QjPEH
X-Google-Smtp-Source: AGHT+IEONgqKEBIKKEfxy6KqVuWFBifYP03CUa3eQoTaRIZLTqPFS46hvctnOIblG0cwaqXVGJG79w==
X-Received: by 2002:a17:902:ec89:b0:1e4:344e:768e with SMTP id x9-20020a170902ec8900b001e4344e768emr12639663plg.5.1714404678388;
        Mon, 29 Apr 2024 08:31:18 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b001e83a70d774sm20818284pln.187.2024.04.29.08.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:31:17 -0700 (PDT)
Date: Mon, 29 Apr 2024 23:31:14 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, n26122115@gs.ncku.edu.tw,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi+9Qq8QnoG6oxLI@visitorckw-System-Product-Name>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
 <Zi50cAgR8nZvgLa3@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi50cAgR8nZvgLa3@yury-ThinkPad>

On Sun, Apr 28, 2024 at 09:08:26AM -0700, Yury Norov wrote:
> + Rasmus
> 
> On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
> > Before:
> >                Start testing find_bit() with random-filled bitmap
> > [    0.299085] fbcon: Taking over console
> > [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
> > [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
> > [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
> > [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
> > [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
> > [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
> > [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
> > [    0.321918] 
> >                Start testing find_bit() with sparse bitmap
> > [    0.321953] find_next_bit:                    7931 ns,    656 iterations
> > [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
> > [    0.323210] find_last_bit:                    8000 ns,    656 iterations
> > [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
> > [    0.324813] find_first_bit:                 384747 ns,    656 iterations
> > [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
> > [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
> > 
> > After:
> >                Start testing find_bit() with random-filled bitmap
> > [    0.305081] fbcon: Taking over console
> > [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
> > [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
> > [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
> > [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
> > [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
> > [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
> > [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
> > [    0.327504] 
> >                Start testing find_bit() with sparse bitmap
> > [    0.327539] find_next_bit:                    7633 ns,    656 iterations
> > [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
> > [    0.328797] find_last_bit:                    8425 ns,    656 iterations
> > [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
> > [    0.330428] find_first_bit:                 392086 ns,    656 iterations
> > [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
> > [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
> > 
> > Some benchmarks seem to have worsened after applying this patch.
> > However, unless I'm mistaken, the fns() changes should only affect the
> > results of find_nth_bit, while the others are just random fluctuations.
> 
> So...
> 
> The patch itself looks good, and indeed it should not affect
> anything except find_nth_bit(). But -40% for find_next_bit()
> and find_next_zero_bit(), and -25% for find_last_bit() don't
> look like a fluctuation by any measure.
> 
> Looking at the numbers, I can only guess that your testing machine
> isn't trustworthy, which means that +18% for find_nth_bit() is not
> trustworthy as well. Maybe it's a sort of virtualized environment?
>
I've retested the patch against Linux v6.9-rc6, running three
iterations before and after applying the patch. The data now appears to
be much more consistent and shows a clear efficiency improvement in the
benchmark for find_nth_bit.

I believe there may have been an error in my previous testing that I
didn't catch. Here are the results from the three runs before and after
applying the patch:

Before:

# run1:
[    0.295555] 
               Start testing find_bit() with random-filled bitmap
[    0.295557] fbcon: Taking over console
[    0.296287] find_next_bit:                  602426 ns, 163845 iterations
[    0.296933] find_next_zero_bit:             643572 ns, 163836 iterations
[    0.297456] find_last_bit:                  521223 ns, 163844 iterations
[    0.301680] find_nth_bit:                  4223086 ns,  16358 iterations
[    0.302865] find_first_bit:                1183479 ns,  16359 iterations
[    0.318173] find_first_and_bit:           15304868 ns,  32955 iterations
[    0.318473] find_next_and_bit:              297802 ns,  74031 iterations
[    0.318474] 
               Start testing find_bit() with sparse bitmap
[    0.318508] find_next_bit:                    7892 ns,    653 iterations
[    0.319758] find_next_zero_bit:            1248034 ns, 327028 iterations
[    0.319767] find_last_bit:                    7818 ns,    653 iterations
[    0.320995] find_nth_bit:                  1224578 ns,    652 iterations
[    0.321383] find_first_bit:                 387053 ns,    653 iterations
[    0.321387] find_first_and_bit:               2005 ns,      1 iterations
[    0.321390] find_next_and_bit:                1833 ns,      1 iterations
[    0.321391] test_bitmap: loaded.
[    0.321454] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 189
[    0.321465] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 564
[    0.322496] test_bitmap: all 6564 tests passed

# run2:
[    0.295442] 
               Start testing find_bit() with random-filled bitmap
[    0.295445] fbcon: Taking over console
[    0.296182] find_next_bit:                  603891 ns, 164170 iterations
[    0.296825] find_next_zero_bit:             642025 ns, 163511 iterations
[    0.297357] find_last_bit:                  529755 ns, 164170 iterations
[    0.301671] find_nth_bit:                  4312387 ns,  16590 iterations
[    0.302876] find_first_bit:                1203730 ns,  16591 iterations
[    0.317946] find_first_and_bit:           15067894 ns,  32773 iterations
[    0.318247] find_next_and_bit:              297303 ns,  73781 iterations
[    0.318248] 
               Start testing find_bit() with sparse bitmap
[    0.318283] find_next_bit:                    8193 ns,    654 iterations
[    0.319532] find_next_zero_bit:            1247954 ns, 327027 iterations
[    0.319541] find_last_bit:                    7530 ns,    654 iterations
[    0.320750] find_nth_bit:                  1205862 ns,    653 iterations
[    0.321134] find_first_bit:                 381843 ns,    654 iterations
[    0.321138] find_first_and_bit:               2087 ns,      1 iterations
[    0.321141] find_next_and_bit:                1843 ns,      1 iterations
[    0.321142] test_bitmap: loaded.
[    0.321207] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 162
[    0.321225] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 1079
[    0.322286] test_bitmap: all 6564 tests passed

# run3:
[    0.295315] 
               Start testing find_bit() with random-filled bitmap
[    0.295318] fbcon: Taking over console
[    0.296054] find_next_bit:                  604012 ns, 163612 iterations
[    0.296697] find_next_zero_bit:             641051 ns, 164069 iterations
[    0.297220] find_last_bit:                  521720 ns, 163611 iterations
[    0.301476] find_nth_bit:                  4254313 ns,  16525 iterations
[    0.302667] find_first_bit:                1189415 ns,  16526 iterations
[    0.317626] find_first_and_bit:           14955907 ns,  32801 iterations
[    0.317924] find_next_and_bit:              296492 ns,  73456 iterations
[    0.317925] 
               Start testing find_bit() with sparse bitmap
[    0.317959] find_next_bit:                    8187 ns,    656 iterations
[    0.319208] find_next_zero_bit:            1247622 ns, 327025 iterations
[    0.319218] find_last_bit:                    8146 ns,    656 iterations
[    0.320406] find_nth_bit:                  1184997 ns,    655 iterations
[    0.320784] find_first_bit:                 376883 ns,    656 iterations
[    0.320788] find_first_and_bit:               2270 ns,      1 iterations
[    0.320791] find_next_and_bit:                1844 ns,      1 iterations
[    0.320793] test_bitmap: loaded.
[    0.320856] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 176
[    0.320868] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 624
[    0.321903] test_bitmap: all 6564 tests passed

After:

# run1:
[    0.299444] 
               Start testing find_bit() with random-filled bitmap
[    0.299446] fbcon: Taking over console
[    0.300176] find_next_bit:                  601818 ns, 163940 iterations
[    0.300820] find_next_zero_bit:             642027 ns, 163741 iterations
[    0.301350] find_last_bit:                  528024 ns, 163939 iterations
[    0.304680] find_nth_bit:                  3329159 ns,  16479 iterations
[    0.305868] find_first_bit:                1186153 ns,  16480 iterations
[    0.320205] find_first_and_bit:           14334269 ns,  32836 iterations
[    0.320504] find_next_and_bit:              297451 ns,  73788 iterations
[    0.320505] 
               Start testing find_bit() with sparse bitmap
[    0.320539] find_next_bit:                    7372 ns,    655 iterations
[    0.321789] find_next_zero_bit:            1248188 ns, 327026 iterations
[    0.321799] find_last_bit:                    8284 ns,    655 iterations
[    0.323032] find_nth_bit:                  1229792 ns,    654 iterations
[    0.323422] find_first_bit:                 389751 ns,    655 iterations
[    0.323426] find_first_and_bit:               2166 ns,      1 iterations
[    0.323430] find_next_and_bit:                1834 ns,      1 iterations
[    0.323431] test_bitmap: loaded.
[    0.323494] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 184
[    0.323505] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 503
[    0.324560] test_bitmap: all 6564 tests passed

# run2:
[    0.295331] 
               Start testing find_bit() with random-filled bitmap
[    0.295333] fbcon: Taking over console
[    0.296066] find_next_bit:                  600626 ns, 163710 iterations
[    0.296713] find_next_zero_bit:             644866 ns, 163971 iterations
[    0.297243] find_last_bit:                  528601 ns, 163711 iterations
[    0.300570] find_nth_bit:                  3325597 ns,  16300 iterations
[    0.301751] find_first_bit:                1179476 ns,  16301 iterations
[    0.316235] find_first_and_bit:           14480647 ns,  32619 iterations
[    0.316536] find_next_and_bit:              298766 ns,  73682 iterations
[    0.316537] 
               Start testing find_bit() with sparse bitmap
[    0.316571] find_next_bit:                    7277 ns,    656 iterations
[    0.317820] find_next_zero_bit:            1248426 ns, 327025 iterations
[    0.317829] find_last_bit:                    7801 ns,    656 iterations
[    0.319052] find_nth_bit:                  1219313 ns,    655 iterations
[    0.319439] find_first_bit:                 386162 ns,    656 iterations
[    0.319443] find_first_and_bit:               1869 ns,      1 iterations
[    0.319446] find_next_and_bit:                1827 ns,      1 iterations
[    0.319448] test_bitmap: loaded.
[    0.319511] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 172
[    0.319522] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 492
[    0.320568] test_bitmap: all 6564 tests passed

# run3:
[    0.299355] 
               Start testing find_bit() with random-filled bitmap
[    0.299357] fbcon: Taking over console
[    0.300087] find_next_bit:                  601452 ns, 163877 iterations
[    0.300735] find_next_zero_bit:             646048 ns, 163804 iterations
[    0.301256] find_last_bit:                  519870 ns, 163877 iterations
[    0.304620] find_nth_bit:                  3362863 ns,  16501 iterations
[    0.305818] find_first_bit:                1195522 ns,  16502 iterations
[    0.320875] find_first_and_bit:           15054509 ns,  32826 iterations
[    0.321172] find_next_and_bit:              295444 ns,  73697 iterations
[    0.321173] 
               Start testing find_bit() with sparse bitmap
[    0.321207] find_next_bit:                    7366 ns,    656 iterations
[    0.322456] find_next_zero_bit:            1248232 ns, 327025 iterations
[    0.322466] find_last_bit:                    8266 ns,    656 iterations
[    0.323732] find_nth_bit:                  1262568 ns,    655 iterations
[    0.324133] find_first_bit:                 400010 ns,    656 iterations
[    0.324137] find_first_and_bit:               2000 ns,      1 iterations
[    0.324140] find_next_and_bit:                1824 ns,      1 iterations
[    0.324141] test_bitmap: loaded.
[    0.324204] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 187
[    0.324218] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 540
[    0.325256] test_bitmap: all 6564 tests passed

> Can you share more about your hardware? Can you make sure it's a bare
> metal machine and run your test compiled in the kernel? That way it
> will run at boot time, at least before any possible userspace payload.
> Can you also run test_bitmap? It has some functional testing for the
> function?
> 
Both the previous and current tests were conducted on real hardware
during the boot phase. While I did test in a qemu environment
previously, it was solely for validation purposes and not for
performance testing. Below is the hardware information I used:

$ lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          39 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   16
  On-line CPU(s) list:    0-15
Vendor ID:                GenuineIntel
  Model name:             11th Gen Intel(R) Core(TM) i7-11700 @ 2.50GHz
    CPU family:           6
    Model:                167
    Thread(s) per core:   2
    Core(s) per socket:   8
    Socket(s):            1
    Stepping:             1
    CPU max MHz:          4900.0000
    CPU min MHz:          800.0000
    BogoMIPS:             4992.00
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe sy
                          scall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc
                          _known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic mo
                          vbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb ssbd ibrs ibpb stibp ibr
                          s_enhanced tpr_shadow flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx avx512f avx512
                          dq rdseed adx smap avx512ifma clflushopt intel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves dtherm 
                          ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp hwp_pkg_req vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes v
                          pclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid fsrm md_clear flush_l1d arch_capabilities
Virtualization features:  
  Virtualization:         VT-x
Caches (sum of all):      
  L1d:                    384 KiB (8 instances)
  L1i:                    256 KiB (8 instances)
  L2:                     4 MiB (8 instances)
  L3:                     16 MiB (1 instance)
NUMA:                     
  NUMA node(s):           1
  NUMA node0 CPU(s):      0-15
Vulnerabilities:          
  Gather data sampling:   Mitigation; Microcode
  Itlb multihit:          Not affected
  L1tf:                   Not affected
  Mds:                    Not affected
  Meltdown:               Not affected
  Mmio stale data:        Mitigation; Clear CPU buffers; SMT vulnerable
  Reg file data sampling: Not affected
  Retbleed:               Mitigation; Enhanced IBRS
  Spec rstack overflow:   Not affected
  Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:             Mitigation; Enhanced / Automatic IBRS; IBPB conditional; RSB filling; PBRSB-eIBRS SW sequence; BHI SW loop, KVM SW loop
  Srbds:                  Not affected
  Tsx async abort:        Not affected


> > Should I include the above benchmark data in the commit message and
> > send a v2 patch?
> 
> Yes, I'd like to do so. Because the current benchmark numbers look so
> weird, can you run it again? Maybe several times before and after, to
> estimate the scatter. Also please run the test_bitmap to check
> functional correctness.
> 
> Since you already have a code testing the performance of fns(), can
> you add it in lib/find_bit_benchmark or lib/test_bitops in a following
> patch?
> 
Sure, I can do that.
I'll include the benchmark data along with the testing code in the v2
patch series that I'll send.

Regards,
Kuan-Wei

>  
> > Additionally, I apologize for you not receiving the email. I received
> > the following "Message not delivered" email, but I'm unsure if it's
> > related and what caused the error:
