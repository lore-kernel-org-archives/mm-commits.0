Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C3D3A1A37
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803208; cv=none; b=hCXgV80F/keJ14lKozMSscIg1oUezKE40+uovmazQc2tnSg5MV6bvUgCKdAltwDkWaRNXiIIIazaK1Ji7BCTXpoGnAR/XxqjYBQwplSijbC/LSwF0miAkqokNUElR/n+FGk8RxQlzU0AwOIjdUE5/6ugsrtPwwNXy908vAmvbIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803208; c=relaxed/simple;
	bh=hskTwyDN2+VOgnkeAjb0DVN7524pbiOPlndG2r/UAzo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PDp6VmU4VVJLae2QfMuoyDK29q1AdCmsj00YBPG/i9sxb2IG/NyfF45QPQXbymUnQhbyS0LTwdLqsS89BbeYEAvX3dElRD5RJIxmDp4SanydJWKME2l3Y2bvZ3QQ0x2zVEjNQWXDauTFaI0orotsDJ6xb6QhaNzd710W66ddOGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3910513AA51;
	Wed,  7 Jan 2026 16:26:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id C6BC660017;
	Wed,  7 Jan 2026 16:26:33 +0000 (UTC)
Date: Wed, 7 Jan 2026 11:27:00 -0500
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
Message-ID: <20260107112700.1c1ce18e@gandalf.local.home>
In-Reply-To: <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 53pkkjaietpn5c73f3m3kaqq84449sor
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: C6BC660017
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX188EDxMSswq70guiHkLk4YTjiuSflt+DRc=
X-HE-Tag: 1767803193-199890
X-HE-Meta: U2FsdGVkX1/iYQiyDubLXUhJzueTTnjpi4Z84+7D9w2SvJifIjqw8ttGrrt2rNGnjAeJ0K92J/Xvjcaw9iu+hnb5tXUY2BfbHW/Uq5qExhVoYmeHD11FGSOX3pFybQmUT4txvHknce+K7nZEkyS/ej9/PPSrR4WiBTOooxPEkfWnnNkG69CZi6Ty/vjgeLH8enaBpdDhfH320IiF77rGbXl7RQmH5OstDbRybT3VxtRX9P1MPl+oM0ovhDCpqjwbgMK25s8Z7+JnODQA6q+gGX01qxqx222Vs5GVJJM5r98HWpnqxA+uJFD8o1FFW+FmU3NzziLGI/gxEVf0b4I6B+XL6nRSHViEdzjWjCv5Uz/CXR3Ok5S/pJuCS3q7MbN1l0wFAfz8iTY=

On Tue, 6 Jan 2026 17:30:32 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

>   AR      arch/x86/entry/built-in.a
> In file included from ./include/trace/define_trace.h:132,
>                  from ./include/trace/events/vmscan.h:554,
>                  from mm/vmscan.c:73:
> ./include/trace/events/vmscan.h: In function =E2=80=98do_trace_event_raw_=
event_mm_shrink_slab_start=E2=80=99:
> ./include/trace/events/vmscan.h:238:68: error: invalid use of undefined t=
ype =E2=80=98struct mem_cgroup=E2=80=99
>   238 |                 __entry->memcg_id =3D sc->memcg ? cgroup_id(sc->m=
emcg->css.cgroup) : 0;
>       |                                                                  =
  ^~
> ./include/trace/trace_events.h:427:11: note: in definition of macro =E2=
=80=98__DECLARE_EVENT_CLASS=E2=80=99

OK, the bug isn't the patch I wrote. It's with the patch that was added on
top of it.

   https://lore.kernel.org/all/20260105160423.23708-2-tballasi@linux.micros=
oft.com/

Which added:

@@ -208,31 +215,34 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
-		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
 		__field(unsigned long, gfp_flags)
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
 		__field(int, priority)
+		__field(int, nid)
+		__field(unsigned short, memcg_id)
 	),
=20
 	TP_fast_assign(
 		__entry->shr =3D shr;
 		__entry->shrink =3D shr->scan_objects;
-		__entry->nid =3D sc->nid;
 		__entry->nr_objects_to_shrink =3D nr_objects_to_shrink;
 		__entry->gfp_flags =3D (__force unsigned long)sc->gfp_mask;
 		__entry->cache_items =3D cache_items;
 		__entry->delta =3D delta;
 		__entry->total_scan =3D total_scan;
 		__entry->priority =3D priority;
+		__entry->nid =3D sc->nid;
+		__entry->memcg_id =3D sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
 	),
=20
-	TP_printk("%pS %p: nid: %d objects to shrink %ld gfp_flags %s cache items=
 %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %=
s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,


Appears that the dereferencing of sc->memcg that was added is dependent on =
CONFIG_MEMCG.

Thus, not my fault ;-)

-- Steve
